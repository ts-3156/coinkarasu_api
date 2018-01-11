class Coincheck::SalesRate < ApplicationRecord
  def as_json(options = nil)
    super(only: %i(from_symbol to_symbol rate created_at))
  end
end
