class Cryptocompare::CoinSnapshot < ApplicationRecord
  validates :from_symbol, presence: true, format: {with: /\A[A-Z0-9]{1,10}\z/}
  validates :to_symbol, presence: true, format: {with: /\A[A-Z0-9]{1,10}\z/}
  validates :data, presence: true

  class << self
    def create_from_response!(res)
      json = JSON.parse(res)
      data = json['Data']['Exchanges'].map do |row|
        {market: row['MARKET'], volume: row['VOLUME24HOUR']}
      end
      create!(
          from_symbol: json['Data']['AggregatedData']['FROMSYMBOL'],
          to_symbol: json['Data']['AggregatedData']['TOSYMBOL'],
          data: data)
    end
  end
end
