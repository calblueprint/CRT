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

ActiveRecord::Schema.define(version: 20151022012221) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "data_types", force: :cascade do |t|
    t.string   "formula"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "order"
  end

  create_table "data_values", force: :cascade do |t|
    t.integer  "type"
    t.decimal  "value"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "year_id"
    t.integer  "data_type_id"
  end

  add_index "data_values", ["data_type_id"], name: "index_data_values_on_data_type_id", using: :btree
  add_index "data_values", ["year_id"], name: "index_data_values_on_year_id", using: :btree

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
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "years", force: :cascade do |t|
    t.date     "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "project_id"
  end

  add_index "years", ["project_id"], name: "index_years_on_project_id", using: :btree

  add_foreign_key "data_values", "data_types"
  add_foreign_key "data_values", "years"
  add_foreign_key "years", "projects"
end
