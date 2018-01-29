namespace :coincheck do
  namespace :sales_rates do
    desc 'update'
    task update: :environment do
      client = CoincheckClient.new
      records = []
      error = 0

      %w(eth etc lsk fct xmr rep xrp zec xem ltc dash bch).each do |from|
        %w(jpy).each do |to|
          begin
            json = JSON.parse client.read_rate(pair: "#{from}_#{to}").body
            records << [from.upcase, to.upcase, json['rate']]
          rescue => e
            puts "#{Time.zone.now} error from=#{from} to=#{to} #{e.inspect}"
            break if (error += 1) >= 3
          end
        end
      end

      Coincheck::SalesRate.import(%i(from_symbol to_symbol rate), records)
    end
  end
end
