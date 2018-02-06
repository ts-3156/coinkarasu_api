namespace :cryptocompare do
  namespace :price_multi_fulls do
    desc 'update'
    task update: :environment do |t|
      url = 'https://min-api.cryptocompare.com/data/pricemultifull?'
      error = 0
      m = Mutex.new
      processed = Queue.new
      messages = []

      pairs = Cryptocompare::TopPair.symbols_pairs
                  .group_by {|from, to| to}
                  .map {|to, syms| [to, syms.map(&:first).uniq]}

      pairs.each do |to, from_symbols|
        Parallel.each(from_symbols.each_slice(20), in_threads: 3) do |from|
          begin
            res = Net::HTTP.get(URI.parse(url + 'fsyms=' + from.join(',') + '&tsyms=' + to))
            processed << [from, to, res] if res
          rescue => e
            m.synchronize {error += 1}
            messages << "#{Time.zone.now} #{t.name} fetch error from=#{from} to=#{to} #{e.inspect}"
            if error >= 30
              messages << 'Suspended since too many errors'
              raise Parallel::Break
            end
          end
        end
      end

      records = []

      processed.size.times.map {processed.pop}.each do |from, to, res|
        begin
          records.concat Cryptocompare::PriceMultiFull.build_from_response(res)
        rescue => e
          if Cryptocompare::PriceMultiFull::IGNORE_LIST.none? {|f, _t| from == f && to == _t}
            messages << "#{Time.zone.now} #{t.name} build error from=#{from} to=#{to} res=#{res} #{e.inspect}"
          end
        end
      end

      Cryptocompare::PriceMultiFull.import(records)
      messages.each {|msg| puts msg}
      SlackClient.cron.ping("#{t.name} ```#{messages.join("\n")}```") if messages.any?
    end
  end
end
