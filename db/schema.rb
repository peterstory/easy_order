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

ActiveRecord::Schema.define(version: 20131117230214) do

  create_table "friendships", force: true do |t|
    t.integer  "user_id",    null: false
    t.integer  "friend_id",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "line_items", force: true do |t|
    t.integer  "participant_id"
    t.integer  "order_id"
    t.string   "name",           null: false
    t.float    "price",          null: false
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "line_items", ["order_id"], name: "index_line_items_on_order_id"
  add_index "line_items", ["participant_id"], name: "index_line_items_on_participant_id"

  create_table "menus", force: true do |t|
    t.string   "name"
    t.string   "content_type"
    t.binary   "data",          limit: 52428800
    t.integer  "restaurant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "menus", ["restaurant_id"], name: "index_menus_on_restaurant_id"

  create_table "orders", force: true do |t|
    t.integer  "restaurant_id", null: false
    t.integer  "organizer_id",  null: false
    t.string   "type",          null: false
    t.float    "total"
    t.string   "status",        null: false
    t.datetime "placed_at",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "orders", ["restaurant_id"], name: "index_orders_on_restaurant_id"

  create_table "participants", force: true do |t|
    t.integer  "user_id"
    t.integer  "order_id"
    t.string   "role",       null: false
    t.float    "total"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "participants", ["order_id"], name: "index_participants_on_order_id"
  add_index "participants", ["user_id"], name: "index_participants_on_user_id"

  create_table "restaurants", force: true do |t|
    t.string   "name",            null: false
    t.text     "description"
    t.string   "cuisine",         null: false
    t.string   "street1",         null: false
    t.string   "street2"
    t.string   "city",            null: false
    t.string   "state",           null: false
    t.string   "zipcode",         null: false
    t.string   "phone",           null: false
    t.string   "fax"
    t.string   "url",             null: false
    t.boolean  "delivers"
    t.float    "delivery_charge"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name",       null: false
    t.string   "email",      null: false
    t.string   "password",   null: false
    t.string   "role",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
