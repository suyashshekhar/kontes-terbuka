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

ActiveRecord::Schema.define(version: 20160507220530) do

  create_table "contests", force: :cascade do |t|
    t.string   "name"
    t.string   "type"
    t.integer  "number_of_short_questions"
    t.integer  "number_of_long_questions"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_on"
    t.datetime "last_updated_on"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "long_submissions", force: :cascade do |t|
    t.string   "name"
    t.string   "attachment"
    t.integer  "problem_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.integer  "contest_id"
  end

  add_index "long_submissions", ["contest_id"], name: "index_long_submissions_on_contest_id"
  add_index "long_submissions", ["user_id"], name: "index_long_submissions_on_user_id"

  create_table "provinces", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], name: "index_roles_on_name"

  create_table "short_problems", force: :cascade do |t|
    t.integer  "contest_id"
    t.integer  "problem_no"
    t.string   "statement"
    t.integer  "answer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "short_problems", ["contest_id"], name: "index_short_problems_on_contest_id"

  create_table "short_submissions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "short_problem_id"
    t.integer  "answer"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "statuses", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "email"
    t.string   "hashed_password"
    t.string   "fullname"
    t.string   "province"
    t.string   "status"
    t.string   "school"
    t.integer  "point"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "salt"
    t.string   "auth_token"
    t.integer  "province_id"
    t.integer  "status_id"
  end

  add_index "users", ["province_id"], name: "index_users_on_province_id"
  add_index "users", ["status_id"], name: "index_users_on_status_id"

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"

end
