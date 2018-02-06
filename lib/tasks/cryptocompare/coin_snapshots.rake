namespace :cryptocompare do
  namespace :coin_snapshots do
    desc 'update'
    task update: :environment do |t|
      url = 'https://www.cryptocompare.com/api/data/coinsnapshot/?'
      error = 0
      m = Mutex.new
      processed = Queue.new
      messages = []

      pairs = Cryptocompare::TopPair.symbols_pairs

      Parallel.each(pairs, in_threads: 3) do |from, to|
        begin
          res = Net::HTTP.get(URI.parse(url + 'fsym=' + from + '&tsym=' + to))
          processed << [from, to, res] if res
        rescue => e
          m.synchronize {error += 1}
          messages << "#{Time.zone.now} #{t.name} fetch error from=#{from} to=#{to} #{e.inspect}"
          if error >= pairs.size / 10
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
          if Cryptocompare::CoinSnapshot::IGNORE_LIST.none? {|f, _t| from == f && to == _t}
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
