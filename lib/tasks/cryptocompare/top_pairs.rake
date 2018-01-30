namespace :cryptocompare do
  namespace :top_pairs do
    desc 'update'
    task update: :environment do |t|
      url = 'https://min-api.cryptocompare.com/data/top/pairs?limit=1000&fsym='
      error = 0
      m = Mutex.new
      processed = Queue.new
      messages = []

      Parallel.each(Cryptocompare::TopPair::SYMBOLS, in_threads: 3) do |from|
        begin
          res = Net::HTTP.get(URI.parse(url + from))
          processed << [from, res] if res
        rescue => e
          m.synchronize {error += 1}
          messages << "#{Time.zone.now} #{t.name} fetch error from=#{from} #{e.inspect}"
          if error >= Cryptocompare::TopPair::SYMBOLS.size / 10
            messages << 'Suspended since too many errors'
            raise Parallel::Break
          end
        end
      end

      records = []

      processed.size.times.map {processed.pop}.each do |from, res|
        begin
          records << Cryptocompare::TopPair.build_from_response(res)
        rescue => e
          messages << "#{Time.zone.now} #{t.name} build error from=#{from} res=#{res} #{e.inspect}"
        end
      end

      Cryptocompare::TopPair.import(records)
      messages.each {|msg| puts msg}
      SlackClient.new.ping("#{t.name} ```#{messages.join("\n")}```") if messages.any?
    end
  end
end
