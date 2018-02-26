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

ActiveRecord::Schema.define(version: 20171124175359) do

  create_table "identities", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "accesstoken"
    t.string   "refreshtoken"
    t.string   "uid"
    t.string   "name"
    t.string   "email"
    t.string   "nickname"
    t.string   "image"
    t.string   "phone"
    t.string   "urls"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "identities", ["user_id"], name: "index_identities_on_user_id"

  create_table "orders", force: :cascade do |t|
    t.integer  "post_id"
    t.integer  "user_id"
    t.boolean  "current"
    t.integer  "quantity"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "submitted",  default: false
    t.boolean  "archived",   default: false
    t.boolean  "cancelled",  default: false
    t.integer  "week_id"
  end

  add_index "orders", ["post_id"], name: "index_orders_on_post_id"
  add_index "orders", ["user_id"], name: "index_orders_on_user_id"
  add_index "orders", ["week_id"], name: "index_orders_on_week_id"

  create_table "posts", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "description"
    t.string   "price"
    t.string   "unit"
    t.boolean  "active",               default: true
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "max_avaliable",        default: "0"
    t.string   "special_instructions"
    t.boolean  "archived",             default: false
    t.integer  "week_id"
  end

  add_index "posts", ["title"], name: "index_posts_on_title"
  add_index "posts", ["week_id"], name: "index_posts_on_week_id"

  create_table "profiles", force: :cascade do |t|
    t.integer  "user_id"
    t.boolean  "seller",           default: false
    t.string   "name"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
    t.string   "phone_number"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.boolean  "registered",       default: false
    t.boolean  "terms_of_service", default: false
    t.string   "minimum_order",    default: "0"
    t.string   "order_total",      default: "0"
    t.string   "business_name"
    t.string   "payable_to"
    t.string   "firstname"
    t.string   "lastname"
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
    t.string   "provider"
    t.string   "uid"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "weeks", force: :cascade do |t|
    t.date     "start"
    t.date     "end"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
