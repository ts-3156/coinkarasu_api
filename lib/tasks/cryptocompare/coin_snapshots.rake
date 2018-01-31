namespace :cryptocompare do
  namespace :coin_snapshots do
    desc 'update'
    task update: :environment do |t|
      url = 'https://www.cryptocompare.com/api/data/coinsnapshot/?'
      error = 0
      m = Mutex.new
      processed = Queue.new
      messages = []

      # クエリの実行回数を減らすために、決め打ちのlimit付きで一括取得する
      # 最新のレコードのみを残すためにindex_byの前にreverseしている
      top_pairs = Cryptocompare::TopPair
                      .order(created_at: :desc)
                      .where(from_symbol: Cryptocompare::TopPair::SYMBOLS)
                      .limit(Cryptocompare::TopPair::SYMBOLS.size)
                      .reverse
                      .index_by(&:from_symbol)

      candidates = []

      Cryptocompare::TopPair::SYMBOLS.each do |from|
        top_pair = top_pairs[from]
        unless top_pair
          # 最初のクエリで取りこぼした時のために、念のため取得する
          top_pair = Cryptocompare::TopPair.order(created_at: :desc).find_by(from_symbol: from)
        end
        next unless top_pair

        top_pair.data.map {|pair| pair['to_symbol']}.uniq.each do |to|
          candidates << [from, to]
        end
      end

      Parallel.each(candidates, in_threads: 3) do |from, to|
        begin
          res = Net::HTTP.get(URI.parse(url + 'fsym=' + from + '&tsym=' + to))
          processed << [from, to, res] if res
        rescue => e
          m.synchronize {error += 1}
          messages << "#{Time.zone.now} #{t.name} fetch error from=#{from} to=#{to} #{e.inspect}"
          if error >= candidates.size / 10
            messages << 'Suspended since too many errors'
            raise Parallel::Break
          end
        end
      end

      records = []

      processed.size.times.map {processed.pop}.each do |from, to, res|
        begin
          records << Cryptocompare::CoinSnapshot.build_from_response(res)
        rescue => e
          unless Cryptocompare::CoinSnapshot::IGNORE_LIST.any? {|f, _t| from == f && to == _t}
            messages << "#{Time.zone.now} #{t.name} build error from=#{from} to=#{to} res=#{res} #{e.inspect}"
          end
        end
      end

      Cryptocompare::CoinSnapshot.import(records)
      messages.each {|msg| puts msg}
      SlackClient.cron.ping("#{t.name} ```#{messages.join("\n")}```") if messages.any?
    end
  end
end
