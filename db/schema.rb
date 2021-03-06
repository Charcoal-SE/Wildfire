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

ActiveRecord::Schema.define(version: 20151009010309) do

  create_table "flag_queues", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.integer  "user_id"
    t.integer  "frequency",  default: 7200
    t.datetime "last_run",   default: '2015-10-08 19:47:15'
    t.integer  "batch_size", default: 1
  end

  add_index "flag_queues", ["user_id"], name: "index_flag_queues_on_user_id"

  create_table "flag_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "flags", force: :cascade do |t|
    t.boolean  "completed",      default: false
    t.string   "failure_reason"
    t.datetime "attempted_at"
    t.integer  "flag_queue_id"
    t.integer  "site_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "post_id"
    t.integer  "flag_type_id"
    t.string   "post_type"
    t.string   "comment_ids"
  end

  create_table "sites", force: :cascade do |t|
    t.string   "site_name"
    t.string   "site_url"
    t.string   "site_logo"
    t.string   "site_domain"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "approved"
    t.string   "access_token"
    t.integer  "account_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
