# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180111113442) do

  create_table "apps", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string "key", null: false
    t.string "secret", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_apps_on_created_at"
    t.index ["key"], name: "index_apps_on_key", unique: true
    t.index ["secret"], name: "index_apps_on_secret", unique: true
  end

  create_table "coincheck_sales_rates", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string "from_symbol", null: false
    t.string "to_symbol", null: false
    t.decimal "rate", precision: 20, scale: 10, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_coincheck_sales_rates_on_created_at"
    t.index ["from_symbol", "to_symbol"], name: "index_coincheck_sales_rates_on_from_symbol_and_to_symbol"
  end

  create_table "coincheck_trading_rates", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string "from_symbol", null: false
    t.string "to_symbol", null: false
    t.decimal "rate", precision: 20, scale: 10, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_coincheck_trading_rates_on_created_at"
  end

end
