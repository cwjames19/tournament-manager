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

ActiveRecord::Schema.define(version: 20160609042053) do

  create_table "matches", force: :cascade do |t|
    t.integer  "num"
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
    t.integer  "tournament_id"
    t.integer  "round"
    t.integer  "sub_bracket"
  end

  add_index "matches", ["tournament_id"], name: "index_matches_on_tournament_id"

  create_table "matches_teams", id: false, force: :cascade do |t|
    t.integer "match_id"
    t.integer "team_id"
  end

  add_index "matches_teams", ["match_id"], name: "index_matches_teams_on_match_id"
  add_index "matches_teams", ["team_id"], name: "index_matches_teams_on_team_id"

  create_table "rounds", force: :cascade do |t|
    t.integer  "tournaments_id"
    t.integer  "sub_brackets_id"
    t.integer  "num"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "rounds", ["sub_brackets_id"], name: "index_rounds_on_sub_brackets_id"
  add_index "rounds", ["tournaments_id"], name: "index_rounds_on_tournaments_id"

  create_table "sub_brackets", force: :cascade do |t|
    t.integer  "tournaments_id"
    t.integer  "num"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "round_counter",  default: 1
  end

  add_index "sub_brackets", ["tournaments_id"], name: "index_sub_brackets_on_tournaments_id"

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.string   "image"
    t.integer  "seed"
    t.integer  "placement"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "tournament_id"
  end

  add_index "teams", ["tournament_id"], name: "index_teams_on_tournament_id"

  create_table "tournaments", force: :cascade do |t|
    t.string   "name"
    t.integer  "tournament_type",     default: 0
    t.integer  "extra_game_option"
    t.string   "image"
    t.boolean  "public",              default: true
    t.text     "teams_raw"
    t.boolean  "normal_scoring"
    t.integer  "user_id"
    t.integer  "teams_id"
    t.integer  "matches_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "num_teams"
    t.integer  "game_counter",        default: 1
    t.integer  "sub_bracket_counter", default: 0
  end

  add_index "tournaments", ["matches_id"], name: "index_tournaments_on_matches_id"
  add_index "tournaments", ["teams_id"], name: "index_tournaments_on_teams_id"
  add_index "tournaments", ["user_id"], name: "index_tournaments_on_user_id"

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
