class CreateCoincheckSalesRates < ActiveRecord::Migration[5.1]
  def change
    create_table :coincheck_sales_rates do |t|
      t.string :from_symbol, null: false
      t.string :to_symbol, null: false
      t.decimal :rate, precision: 20, scale: 10, null: false

      t.timestamps null: false
    end
    add_index :coincheck_sales_rates, [:from_symbol, :to_symbol]
    add_index :coincheck_sales_rates, :created_at
  end
end
