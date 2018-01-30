require 'bigdecimal'
require 'bigdecimal/util'

namespace :coincheck do
  namespace :trading_rates do
    desc 'update'
    task update: :environment do |t|
      client = CoincheckClient.new
      records = []
      messages = []

      %w(btc).each do |from|
        %w(jpy).each do |to|
          begin
            sell = JSON.parse client.read_orders_rate(order_type: 'sell', pair: "#{from}_#{to}", amount: 1).body
            buy = JSON.parse client.read_orders_rate(order_type: 'buy', pair: "#{from}_#{to}", amount: 1).body
            rate = (sell['rate'].to_d + buy['rate'].to_d) / 2.0

            records << [from.upcase, to.upcase, rate]
          rescue => e
            messages << "#{Time.zone.now} #{t.name} error from=#{from} to=#{to} #{e.inspect}"
          end
        end
      end

      Coincheck::TradingRate.import(%i(from_symbol to_symbol rate), records)
      messages.each {|msg| puts msg}
      SlackClient.new.ping("#{t.name} ```#{messages.join("\n")}```") if messages.any?
    end
  end
end
