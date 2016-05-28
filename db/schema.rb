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

ActiveRecord::Schema.define(version: 20160528124333) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "areas", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "location_id"
  end

  add_index "areas", ["location_id"], name: "index_areas_on_location_id", using: :btree

  create_table "bookings", force: :cascade do |t|
    t.integer  "seller_id"
    t.integer  "buyer_id"
    t.integer  "room_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone"
    t.integer  "duration"
    t.integer  "guest"
    t.integer  "subtotal_sens",        default: 0,          null: false
    t.string   "subtotal_currency",    default: "MYR",      null: false
    t.integer  "service_fee_sens",     default: 0,          null: false
    t.string   "service_fee_currency", default: "MYR",      null: false
    t.integer  "total_sens",           default: 0,          null: false
    t.string   "total_currency",       default: "MYR",      null: false
    t.string   "room_name"
    t.string   "room_title"
    t.string   "status",               default: "Upcoming"
    t.boolean  "paid",                 default: false
    t.datetime "check_in"
    t.datetime "check_out"
    t.date     "start_date"
    t.string   "booking_code"
    t.string   "payment_method"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  add_index "bookings", ["buyer_id"], name: "index_bookings_on_buyer_id", using: :btree
  add_index "bookings", ["paid"], name: "index_bookings_on_paid", using: :btree
  add_index "bookings", ["payment_method"], name: "index_bookings_on_payment_method", using: :btree
  add_index "bookings", ["room_id"], name: "index_bookings_on_room_id", using: :btree
  add_index "bookings", ["seller_id"], name: "index_bookings_on_seller_id", using: :btree
  add_index "bookings", ["start_date"], name: "index_bookings_on_start_date", using: :btree

  create_table "locations", force: :cascade do |t|
    t.string   "name"
    t.string   "currency"
    t.string   "currency_symbol"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "rooms", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "area_id"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.boolean  "active",                         default: false
    t.string   "location"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "district"
    t.integer  "price_per_three_hour_sens",      default: 0,     null: false
    t.string   "price_per_three_hour_currency",  default: "MYR", null: false
    t.integer  "price_per_extra_hour_sens",      default: 0,     null: false
    t.string   "price_per_extra_hour_currency",  default: "MYR", null: false
    t.integer  "price_per_extra_guest_sens",     default: 0,     null: false
    t.string   "price_per_extra_guest_currency", default: "MYR", null: false
    t.text     "direction"
    t.integer  "user_id"
    t.integer  "deposit_sens",                   default: 0,     null: false
    t.string   "deposit_currency",               default: "MYR", null: false
    t.string   "room_type"
    t.string   "cover_file_name"
    t.string   "cover_content_type"
    t.integer  "cover_file_size"
    t.datetime "cover_updated_at"
    t.boolean  "restaurant"
    t.boolean  "bar"
    t.boolean  "balcony"
    t.boolean  "free_parking"
    t.boolean  "free_airport_shuttle"
    t.boolean  "free_wifi"
    t.boolean  "meeting_rooms"
    t.boolean  "outdoor_pool"
    t.boolean  "indoor_pool"
    t.boolean  "spa"
    t.boolean  "beauty_center"
    t.boolean  "fitness_room"
    t.boolean  "massage"
    t.boolean  "sauna"
    t.boolean  "jacuzzi"
    t.boolean  "kitchen"
    t.string   "title"
  end

  add_index "rooms", ["area_id"], name: "index_rooms_on_area_id", using: :btree
  add_index "rooms", ["balcony"], name: "index_rooms_on_balcony", using: :btree
  add_index "rooms", ["bar"], name: "index_rooms_on_bar", using: :btree
  add_index "rooms", ["beauty_center"], name: "index_rooms_on_beauty_center", using: :btree
  add_index "rooms", ["fitness_room"], name: "index_rooms_on_fitness_room", using: :btree
  add_index "rooms", ["free_airport_shuttle"], name: "index_rooms_on_free_airport_shuttle", using: :btree
  add_index "rooms", ["free_parking"], name: "index_rooms_on_free_parking", using: :btree
  add_index "rooms", ["free_wifi"], name: "index_rooms_on_free_wifi", using: :btree
  add_index "rooms", ["indoor_pool"], name: "index_rooms_on_indoor_pool", using: :btree
  add_index "rooms", ["jacuzzi"], name: "index_rooms_on_jacuzzi", using: :btree
  add_index "rooms", ["kitchen"], name: "index_rooms_on_kitchen", using: :btree
  add_index "rooms", ["massage"], name: "index_rooms_on_massage", using: :btree
  add_index "rooms", ["meeting_rooms"], name: "index_rooms_on_meeting_rooms", using: :btree
  add_index "rooms", ["outdoor_pool"], name: "index_rooms_on_outdoor_pool", using: :btree
  add_index "rooms", ["restaurant"], name: "index_rooms_on_restaurant", using: :btree
  add_index "rooms", ["sauna"], name: "index_rooms_on_sauna", using: :btree
  add_index "rooms", ["spa"], name: "index_rooms_on_spa", using: :btree
  add_index "rooms", ["title"], name: "index_rooms_on_title", using: :btree
  add_index "rooms", ["user_id"], name: "index_rooms_on_user_id", using: :btree

  create_table "uploads", force: :cascade do |t|
    t.integer  "room_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "uploads", ["room_id"], name: "index_uploads_on_room_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",       null: false
    t.string   "encrypted_password",     default: "",       null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,        null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone"
    t.string   "currency"
    t.string   "role",                   default: "Member"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["role"], name: "index_users_on_role", using: :btree

end
