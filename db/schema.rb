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

ActiveRecord::Schema.define(:version => 20130219074819) do

  create_table "clients", :force => true do |t|
    t.string   "name"
    t.decimal  "hourly_rate",  :precision => 8, :scale => 2
    t.integer  "user_id",                                    :null => false
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.string   "city"
    t.string   "street"
    t.string   "zip"
    t.string   "company_name"
  end

  create_table "contact_data", :force => true do |t|
    t.string   "company"
    t.string   "street"
    t.string   "zip_code"
    t.string   "city"
    t.integer  "user_id"
    t.integer  "client_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "invoices", :force => true do |t|
    t.integer  "user_id"
    t.integer  "client_id"
    t.integer  "number"
    t.integer  "total"
    t.boolean  "includes_vat"
    t.datetime "paid_on"
    t.float    "vat"
    t.text     "note"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.text     "items"
    t.text     "content"
    t.text     "payment_terms"
    t.text     "payment_info"
  end

  create_table "notes", :force => true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "client_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "share_token"
  end

  create_table "start_time_saves", :force => true do |t|
    t.integer  "user_id"
    t.datetime "start_time"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
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
  end

  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token"

  create_table "worklogs", :force => true do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "user_id"
    t.integer  "client_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.decimal  "hourly_rate"
    t.decimal  "price"
    t.text     "summary"
    t.boolean  "paid"
    t.integer  "invoice_id"
  end

end
