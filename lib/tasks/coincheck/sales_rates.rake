namespace :coincheck do
  namespace :sales_rates do
    desc 'update'
    task update: :environment do |t|
      client = CoincheckClient.new
      records = []
      error = 0
      messages = []

      %w(eth etc lsk fct xmr rep xrp zec xem ltc dash bch).each do |from|
        %w(jpy).each do |to|
          begin
            json = JSON.parse client.read_rate(pair: "#{from}_#{to}").body
            records << [from.upcase, to.upcase, json['rate']]
          rescue => e
            messages << "#{Time.zone.now} #{t.name} error from=#{from} to=#{to} #{e.inspect}"
            if (error += 1) >= 3
              messages << 'Suspended since too many errors'
              break
            end
          end
        end
      end

      Coincheck::SalesRate.import(%i(from_symbol to_symbol rate), records)
      messages.each {|msg| puts msg}
      SlackClient.cron.ping("#{t.name} ```#{messages.join("\n")}```") if messages.any?
    end
  end
end
