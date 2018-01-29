namespace :cryptocompare do
  namespace :top_pairs do
    desc 'update'
    task update: :environment do
      url = 'https://min-api.cryptocompare.com/data/top/pairs?limit=1000&fsym='
      error = 0
      m = Mutex.new
      processed = Queue.new

      Parallel.each(Cryptocompare::TopPair::SYMBOLS, in_threads: 3) do |from|
        begin
          res = Net::HTTP.get(URI.parse(url + from))
          processed << [from, res] if res
        rescue => e
          puts "#{Time.zone.now} fetch error from=#{from} #{e.inspect}"
          m.synchronize {error += 1}
          raise Parallel::Break if error >= Cryptocompare::TopPair::SYMBOLS.size / 10
        end
      end

      records = []

      processed.size.times.map {processed.pop}.each do |from, res|
        begin
          records << Cryptocompare::TopPair.build_from_response(res)
        rescue => e
          puts "#{Time.zone.now} build error from=#{from} res=#{res} #{e.inspect}"
        end
      end

      Cryptocompare::TopPair.import(records)
    end
  end
end
