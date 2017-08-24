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

ActiveRecord::Schema.define(version: 20170527104439) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "access_tokens", force: :cascade do |t|
    t.string   "token"
    t.boolean  "expirable",        default: true
    t.datetime "last_activity_at"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "add_attributes_to_users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authentications", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "uid"
    t.string   "provider"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "business_hours", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "workday"
    t.time     "start_time"
    t.time     "end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "business_hours", ["user_id"], name: "index_business_hours_on_user_id", using: :btree

  create_table "client_shares", force: :cascade do |t|
    t.integer  "client_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.integer  "hourly_rate_cents"
    t.boolean  "works_as_subcontractor",          default: false
    t.integer  "subcontractor_hourly_rate_cents", default: 0
    t.string   "subcontractor_shown_name"
  end

  create_table "clients", force: :cascade do |t|
    t.string   "name"
    t.integer  "hourly_rate_cents"
    t.integer  "user_id",                      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "city"
    t.string   "street"
    t.string   "zip"
    t.string   "company_name"
    t.boolean  "email_when_team_adds_worklog"
    t.string   "client_token"
    t.text     "credit_block_reason"
  end

  create_table "expenses", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "client_id"
    t.integer  "total_cents"
    t.text     "reason"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "invoice_id"
  end

  create_table "holidays", force: :cascade do |t|
    t.integer  "user_id"
    t.date     "day"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "invoice_defaults", force: :cascade do |t|
    t.float    "vat"
    t.boolean  "includes_vat"
    t.text     "payment_terms"
    t.text     "payment_info"
    t.text     "note"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "custom_css",    default: ""
  end

  create_table "invoices", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "client_id"
    t.string   "number"
    t.integer  "total_cents"
    t.boolean  "includes_vat"
    t.datetime "paid_on"
    t.float    "vat"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "content"
    t.text     "payment_terms"
    t.text     "payment_info"
    t.integer  "discount_cents"
    t.integer  "subtotal_cents"
    t.datetime "invoice_date"
  end

  create_table "invoices_products", force: :cascade do |t|
    t.integer "product_id"
    t.integer "invoice_id"
  end

  create_table "notes", force: :cascade do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "client_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "share_token"
  end

  create_table "products", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "total_cents"
    t.float    "charge"
    t.text     "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "starburst_announcement_views", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "announcement_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "starburst_announcement_views", ["user_id", "announcement_id"], name: "starburst_announcement_view_index", unique: true, using: :btree

  create_table "starburst_announcements", force: :cascade do |t|
    t.text     "title"
    t.text     "body"
    t.datetime "start_delivering_at"
    t.datetime "stop_delivering_at"
    t.text     "limit_to_users"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "category"
  end

  create_table "team_users", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "team_id"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "team_users", ["team_id"], name: "index_team_users_on_team_id", using: :btree
  add_index "team_users", ["user_id"], name: "index_team_users_on_user_id", using: :btree

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "creator_id"
  end

  create_table "teams_users", id: false, force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "team_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "teams_users", ["team_id"], name: "index_teams_users_on_team_id", using: :btree
  add_index "teams_users", ["user_id"], name: "index_teams_users_on_user_id", using: :btree

  create_table "temp_worklog_saves", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "summary"
    t.string   "from_date"
    t.string   "from_time"
    t.string   "to_date"
    t.string   "to_time"
    t.integer  "client_id"
    t.boolean  "show_user"
    t.integer  "hourly_rate_cents"
  end

  create_table "timeframes", force: :cascade do |t|
    t.datetime "started"
    t.datetime "ended"
    t.integer  "worklog_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                                          null: false
    t.string   "crypted_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.boolean  "show_tutorial",                   default: true
  end

  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", using: :btree

  create_table "worklogs", force: :cascade do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "user_id"
    t.integer  "client_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "hourly_rate_cents"
    t.integer  "total_cents"
    t.text     "summary"
    t.integer  "invoice_id"
    t.datetime "deleted_at"
    t.integer  "client_share_id"
    t.integer  "team_id"
  end

  add_foreign_key "business_hours", "users"
  add_foreign_key "worklogs", "teams"
  add_foreign_key "worklogs", "teams"
end
