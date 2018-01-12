class Coincheck::TradingRate < ApplicationRecord
  validates :from_symbol, presence: true, format: {with: /\A[A-Z0-9]{1,10}\z/}
  validates :to_symbol, presence: true, format: {with: /\A[A-Z0-9]{1,10}\z/}
  validates :rate, presence: true

  def as_json(options = nil)
    super(only: %i(from_symbol to_symbol rate created_at))
  end
end
