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

ActiveRecord::Schema.define(version: 20171119203000) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "address"
    t.string "script_hash"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "assets", force: :cascade do |t|
    t.string "asset_id"
    t.string "asset_type"
    t.string "owner"
    t.string "admin"
    t.string "amount"
    t.integer "precision"
    t.jsonb "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "balances", force: :cascade do |t|
    t.bigint "asset_id"
    t.bigint "account_id"
    t.bigint "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_balances_on_account_id"
    t.index ["asset_id"], name: "index_balances_on_asset_id"
  end

  create_table "blocks", force: :cascade do |t|
    t.bigint "index"
    t.integer "time"
    t.integer "size"
    t.integer "version"
    t.string "merkle_root"
    t.string "nonce"
    t.string "next_consensus"
    t.string "block_hash"
    t.string "prev_block_hash"
    t.string "next_block_hash"
    t.jsonb "script"
    t.jsonb "tx"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["index"], name: "index_blocks_on_index"
  end

  create_table "nodes", force: :cascade do |t|
    t.string "url"
    t.bigint "block_height"
    t.boolean "status"
    t.float "time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "outputs", force: :cascade do |t|
    t.bigint "transaction_id"
    t.bigint "account_id"
    t.bigint "asset_id"
    t.integer "index"
    t.bigint "value"
    t.boolean "claimed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_outputs_on_account_id"
    t.index ["asset_id"], name: "index_outputs_on_asset_id"
    t.index ["transaction_id"], name: "index_outputs_on_transaction_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "block_id"
    t.integer "size"
    t.integer "version"
    t.string "txid"
    t.string "tx_type"
    t.bigint "sys_fee"
    t.bigint "net_fee"
    t.jsonb "data"
    t.jsonb "tx_attributes"
    t.jsonb "vin"
    t.jsonb "vout"
    t.jsonb "scripts"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["block_id"], name: "index_transactions_on_block_id"
  end

end
