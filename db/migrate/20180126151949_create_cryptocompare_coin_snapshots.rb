class CreateCryptocompareCoinSnapshots < ActiveRecord::Migration[5.1]
  def change
    create_table :cryptocompare_coin_snapshots do |t|
      t.string :from_symbol, null: false
      t.string :to_symbol, null: false
      t.json :data, null: false

      t.timestamps null: false
    end
    add_index :cryptocompare_coin_snapshots, :from_symbol
    add_index :cryptocompare_coin_snapshots, :to_symbol
    add_index :cryptocompare_coin_snapshots, :created_at

  end
end
