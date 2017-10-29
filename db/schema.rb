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

ActiveRecord::Schema.define(version: 20170828125406) do

  create_table "microposts", force: :cascade do |t|
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "picture"
    t.integer  "reply_to_user_id"
  end

  add_index "microposts", ["user_id", "created_at"], name: "index_microposts_on_user_id_and_created_at"
  add_index "microposts", ["user_id"], name: "index_microposts_on_user_id"

  create_table "relationships", force: :cascade do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "relationships", ["followed_id"], name: "index_relationships_on_followed_id"
  add_index "relationships", ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true
  add_index "relationships", ["follower_id"], name: "index_relationships_on_follower_id"

  create_table "tel_inquiries", force: :cascade do |t|
    t.boolean  "setting"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "tel_inquiries", ["user_id"], name: "index_tel_inquiries_on_user_id"

  create_table "twilio_incoming_logs", force: :cascade do |t|
    t.string   "sid"
    t.string   "to"
    t.string   "from"
    t.string   "call_status"
    t.integer  "user_id"
    t.integer  "twilio_outgoing_log_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "twilio_incoming_logs", ["twilio_outgoing_log_id"], name: "index_twilio_incoming_logs_on_twilio_outgoing_log_id"
  add_index "twilio_incoming_logs", ["user_id"], name: "index_twilio_incoming_logs_on_user_id"

  create_table "twilio_outgoing_logs", force: :cascade do |t|
    t.string   "sid"
    t.string   "parent_call_sid"
    t.datetime "finished_call_time"
    t.string   "to"
    t.string   "from"
    t.string   "call_status"
    t.string   "duration"
    t.integer  "user_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "twilio_outgoing_logs", ["user_id"], name: "index_twilio_outgoing_logs_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.boolean  "admin",                         default: false
    t.string   "activation_digest"
    t.boolean  "activated",                     default: false
    t.datetime "activated_at"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.string   "screen_name"
    t.text     "profile",           limit: 500
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["screen_name"], name: "index_users_on_screen_name", unique: true

end
