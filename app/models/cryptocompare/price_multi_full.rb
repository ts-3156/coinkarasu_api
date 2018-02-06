class Cryptocompare::PriceMultiFull < ApplicationRecord
  IGNORE_LIST = []

  validates :from_symbol, presence: true, format: {with: /\A[A-Z0-9]{1,10}\z/}
  validates :to_symbol, presence: true, format: {with: /\A[A-Z0-9]{1,10}\z/}
  validates :data, presence: true

  class << self
    def build_from_response(res)
      json = JSON.parse(res)
      json['RAW'].map do |from_symbol, to_symbols|
        to_symbols.map do |to_symbol, attrs|
          new(
              from_symbol: from_symbol,
              to_symbol: to_symbol,
              data: {price: attrs['PRICE'], market_cap: attrs['MKTCAP']})
        end
      end.flatten
    end
  end
end
