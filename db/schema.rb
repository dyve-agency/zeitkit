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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140511001026) do

  create_table "access_tokens", :force => true do |t|
    t.string   "token"
    t.boolean  "expirable",        :default => true
    t.datetime "last_activity_at"
    t.integer  "user_id"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.integer  "uid"
    t.string   "provider"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "client_shares", :force => true do |t|
    t.integer  "client_id"
    t.integer  "user_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "username"
    t.integer  "hourly_rate_cents"
  end

  create_table "clients", :force => true do |t|
    t.string   "name"
    t.integer  "hourly_rate_cents"
    t.integer  "user_id",                      :null => false
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.string   "city"
    t.string   "street"
    t.string   "zip"
    t.string   "company_name"
    t.boolean  "email_when_team_adds_worklog"
  end

  create_table "expenses", :force => true do |t|
    t.integer  "user_id"
    t.integer  "client_id"
    t.integer  "total_cents"
    t.text     "reason"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "invoice_id"
  end

  create_table "invoice_defaults", :force => true do |t|
    t.float    "vat"
    t.boolean  "includes_vat"
    t.text     "payment_terms"
    t.text     "payment_info"
    t.text     "note"
    t.integer  "user_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "invoices", :force => true do |t|
    t.integer  "user_id"
    t.integer  "client_id"
    t.string   "number"
    t.integer  "total_cents"
    t.boolean  "includes_vat"
    t.datetime "paid_on"
    t.float    "vat"
    t.text     "note"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.text     "content"
    t.text     "payment_terms"
    t.text     "payment_info"
    t.integer  "discount_cents"
    t.integer  "subtotal_cents"
  end

  create_table "invoices_products", :force => true do |t|
    t.integer "product_id"
    t.integer "invoice_id"
  end

  create_table "notes", :force => true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "client_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "share_token"
  end

  create_table "products", :force => true do |t|
    t.integer  "user_id"
    t.integer  "total_cents"
    t.float    "charge"
    t.text     "title"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "temp_worklog_saves", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.text     "summary"
    t.string   "from_date"
    t.string   "from_time"
    t.string   "to_date"
    t.string   "to_time"
    t.integer  "client_id"
    t.boolean  "show_user"
    t.integer  "hourly_rate_cents"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                           :null => false
    t.string   "crypted_password"
    t.string   "salt"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.string   "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.string   "city"
    t.string   "street"
    t.string   "zip"
    t.string   "company_name"
    t.string   "currency"
    t.boolean  "signup_email_sent"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "time_zone"
    t.string   "github_token"
    t.string   "username"
  end

  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token"

  create_table "worklogs", :force => true do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "user_id"
    t.integer  "client_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "hourly_rate_cents"
    t.integer  "total_cents"
    t.text     "summary"
    t.integer  "invoice_id"
    t.datetime "deleted_at"
  end

end
