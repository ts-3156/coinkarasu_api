namespace :coincheck do
  namespace :sales_rates do
    desc 'update'
    task update: :environment do
      client = CoincheckClient.new
      error = 0

      %w(eth etc lsk fct xmr rep xrp zec xem ltc dash bch).each do |from|
        %w(jpy).each do |to|
          begin
            json = JSON.parse client.read_rate(pair: "#{from}_#{to}").body
            Coincheck::SalesRate.create!(from_symbol: from.upcase, to_symbol: to.upcase, rate: json['rate'])
          rescue => e
            puts "error from=#{from} to=#{to} #{e.inspect}"
            break if (error += 1) >= 3
          end
        end
      end
    end
  end
end
