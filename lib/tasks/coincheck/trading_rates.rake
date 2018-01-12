require 'bigdecimal'
require 'bigdecimal/util'

namespace :coincheck do
  namespace :trading_rates do
    desc 'update'
    task update: :environment do
      client = CoincheckClient.new

      %w(btc).each do |from|
        %w(jpy).each do |to|
          begin
            sell = JSON.parse client.read_orders_rate(order_type: 'sell', pair: "#{from}_#{to}", amount: 1).body
            buy = JSON.parse client.read_orders_rate(order_type: 'buy', pair: "#{from}_#{to}", amount: 1).body
            rate = (sell['rate'].to_d + buy['rate'].to_d) / 2.0

            Coincheck::TradingRate.create!(from_symbol: from.upcase, to_symbol: to.upcase, rate: rate)
          rescue => e
            puts "#{Time.zone.now} error from=#{from} to=#{to} #{e.inspect}"
          end
        end
      end
    end
  end
end
