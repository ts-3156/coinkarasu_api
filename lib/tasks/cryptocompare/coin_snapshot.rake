namespace :cryptocompare do
  namespace :coin_snapshots do
    desc 'update'
    task update: :environment do
      url = 'https://www.cryptocompare.com/api/data/coinsnapshot/?'
      error = 0
      m = Mutex.new
      processed = Queue.new

      candidates = []

      Cryptocompare::TopPair::SYMBOLS.each do |from|
        top_pair = Cryptocompare::TopPair.order(created_at: :desc).find_by(from_symbol: from)
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
          puts "#{Time.zone.now} fetch error from=#{from} to=#{to} #{e.inspect}"
          m.synchronize {error += 1}
          raise Parallel::Break if error >= candidates.size / 10
        end
      end

      records = []

      processed.size.times.map {processed.pop}.each do |from, to, res|
        begin
          records << Cryptocompare::CoinSnapshot.build_from_response(res)
        rescue => e
          puts "#{Time.zone.now} build error from=#{from} to=#{to} res=#{res} #{e.inspect}"
        end
      end

      Cryptocompare::CoinSnapshot.import(records)
    end
  end
end
