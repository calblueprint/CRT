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

ActiveRecord::Schema.define(version: 20160313011728) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "data_types", force: :cascade do |t|
    t.string   "formula"
    t.string   "name"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "order"
    t.boolean  "master",     default: false
  end

  create_table "data_values", force: :cascade do |t|
    t.integer  "type"
    t.decimal  "value"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "data_type_id",    null: false
    t.integer  "project_year_id", null: false
    t.decimal  "formula_value"
    t.string   "input_formula"
  end

  add_index "data_values", ["data_type_id"], name: "index_data_values_on_data_type_id", using: :btree

  create_table "project_years", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "project_id", null: false
    t.integer  "year_id",    null: false
    t.integer  "date"
  end

  add_index "project_years", ["project_id"], name: "index_project_years_on_project_id", using: :btree

  create_table "projects", force: :cascade do |t|
    t.string   "name"
    t.integer  "acres"
    t.date     "date_closed"
    t.decimal  "restricted_endowment"
    t.decimal  "cap_rate"
    t.decimal  "admin_rate"
    t.decimal  "total_upfront"
    t.integer  "years_upfront"
    t.date     "earnings_begin"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.boolean  "master",               default: false
  end

  add_index "projects", ["master"], name: "index_projects_on_master", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "name"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "years", force: :cascade do |t|
    t.integer  "year",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "data_values", "data_types"
  add_foreign_key "project_years", "projects"
end
