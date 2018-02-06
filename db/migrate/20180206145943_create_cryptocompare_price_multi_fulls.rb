class CreateCryptocomparePriceMultiFulls < ActiveRecord::Migration[5.1]
  def change
    create_table :cryptocompare_price_multi_fulls do |t|
      t.string :from_symbol, null: false
      t.string :to_symbol, null: false
      t.json :data, null: false

      t.timestamps null: false
    end
    add_index :cryptocompare_price_multi_fulls, :from_symbol
    add_index :cryptocompare_price_multi_fulls, :to_symbol
    add_index :cryptocompare_price_multi_fulls, :created_at
  end
end
