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

ActiveRecord::Schema.define(version: 20160519052906) do

  create_table "matches", force: :cascade do |t|
    t.integer  "match_number"
    t.string   "winner"
    t.string   "loser"
    t.string   "team_home"
    t.string   "team_visitor"
    t.string   "result_home"
    t.string   "result_visitor"
    t.string   "overtime_home"
    t.string   "overtime_visitor"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.string   "image"
    t.integer  "seed"
    t.integer  "placement"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tournaments", force: :cascade do |t|
    t.string   "name"
    t.string   "tournament_type",    default: "single elimination"
    t.boolean  "play_out_all_games"
    t.boolean  "bronze_medal_game"
    t.string   "image"
    t.boolean  "public",             default: true
    t.text     "teams"
    t.boolean  "normal_scoring"
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
  end

  create_table "users", force: :cascade do |t|
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
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
