class Cryptocompare::TopPair < ApplicationRecord
  validates :from_symbol, presence: true, format: {with: /\A[A-Z0-9]{1,10}\z/}
  validates :data, presence: true

  class << self
    def create_from_response!(res)
      json = JSON.parse(res)
      data = json['Data'].map do |row|
        {to_symbol: row['toSymbol'], volume: row['volume24h']}
      end
      create!(from_symbol: json['Data'][0]['fromSymbol'], data: data)
    end
  end
end
