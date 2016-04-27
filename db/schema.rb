# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20151029105712) do

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "expense_categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth"
    t.string   "ancestry"
    t.integer  "ancestry_depth", default: 0
  end

  add_index "expense_categories", ["ancestry"], name: "index_expense_categories_on_ancestry", using: :btree
  add_index "expense_categories", ["user_id"], name: "index_expense_categories_on_user_id", using: :btree

  create_table "expense_transactions", force: true do |t|
    t.text     "description"
    t.text     "place"
    t.decimal  "amount_cents",               precision: 10, scale: 0
    t.datetime "date"
    t.integer  "expense_category_id"
    t.text     "type"
    t.string   "expense_type"
    t.integer  "user_id"
    t.integer  "income_transaction_id"
    t.string   "amount_currency",                                     default: "USD", null: false
    t.integer  "income_category_id"
    t.integer  "parent_expense_category_id"
  end

  add_index "expense_transactions", ["income_category_id"], name: "index_expense_transactions_on_income_category_id", using: :btree
  add_index "expense_transactions", ["user_id"], name: "index_expense_transactions_on_user_id", using: :btree

  create_table "finance_lmays", force: true do |t|
    t.string   "incomeexpense"
    t.text     "description"
    t.decimal  "amount",             precision: 10, scale: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_id"
    t.integer  "income_relation_id"
  end

  create_table "income_categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "income_categories", ["user_id"], name: "index_income_categories_on_user_id", using: :btree

  create_table "income_transactions", force: true do |t|
    t.text     "description"
    t.decimal  "amount_cents",       precision: 10, scale: 0
    t.datetime "date"
    t.integer  "income_category_id"
    t.integer  "user_id"
    t.string   "amount_currency",                             default: "USD", null: false
  end

  add_index "income_transactions", ["user_id"], name: "index_income_transactions_on_user_id", using: :btree

  create_table "models", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "models", ["email"], name: "index_models_on_email", unique: true, using: :btree
  add_index "models", ["reset_password_token"], name: "index_models_on_reset_password_token", unique: true, using: :btree

  create_table "transactions", force: true do |t|
    t.string   "incomeexpense"
    t.text     "description"
    t.decimal  "amount",        precision: 10, scale: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_id"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: ""
    t.string   "encrypted_password",     default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
