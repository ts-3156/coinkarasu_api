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

ActiveRecord::Schema.define(version: 20180206145943) do

  create_table "apps", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string "uuid", null: false
    t.string "key", null: false
    t.string "secret", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_apps_on_created_at"
    t.index ["key"], name: "index_apps_on_key", unique: true
    t.index ["secret"], name: "index_apps_on_secret", unique: true
    t.index ["uuid"], name: "index_apps_on_uuid", unique: true
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
    t.index ["from_symbol", "to_symbol"], name: "index_coincheck_trading_rates_on_from_symbol_and_to_symbol"
  end

  create_table "cryptocompare_coin_snapshots", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string "from_symbol", null: false
    t.string "to_symbol", null: false
    t.json "data", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_cryptocompare_coin_snapshots_on_created_at"
    t.index ["from_symbol"], name: "index_cryptocompare_coin_snapshots_on_from_symbol"
    t.index ["to_symbol"], name: "index_cryptocompare_coin_snapshots_on_to_symbol"
  end

  create_table "cryptocompare_price_multi_fulls", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string "from_symbol", null: false
    t.string "to_symbol", null: false
    t.json "data", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_cryptocompare_price_multi_fulls_on_created_at"
    t.index ["from_symbol"], name: "index_cryptocompare_price_multi_fulls_on_from_symbol"
    t.index ["to_symbol"], name: "index_cryptocompare_price_multi_fulls_on_to_symbol"
  end

  create_table "cryptocompare_top_pairs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string "from_symbol", null: false
    t.json "data", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_cryptocompare_top_pairs_on_created_at"
    t.index ["from_symbol"], name: "index_cryptocompare_top_pairs_on_from_symbol"
  end

  create_table "notification_tokens", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string "uuid", null: false
    t.string "token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_notification_tokens_on_created_at"
    t.index ["token"], name: "index_notification_tokens_on_token", unique: true
    t.index ["uuid"], name: "index_notification_tokens_on_uuid", unique: true
  end

end
