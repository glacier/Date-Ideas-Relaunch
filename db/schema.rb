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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110608062134) do

  create_table "assignments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assignments", ["role_id"], :name => "index_assignments_on_role_id"
  add_index "assignments", ["user_id"], :name => "index_assignments_on_user_id"

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "business_categories", :force => true do |t|
    t.integer  "business_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "business_neighbourhoods", :force => true do |t|
    t.integer  "business_id"
    t.integer  "neighbourhood_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "business_types", :force => true do |t|
    t.string   "business_id"
    t.string   "category_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "businesses", :force => true do |t|
    t.string   "venue_type"
    t.string   "logo"
    t.string   "name"
    t.string   "address1"
    t.string   "address2"
    t.string   "address3"
    t.string   "city"
    t.string   "province"
    t.string   "postal_code"
    t.string   "country"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "photo_url",               :default => "business.jpg"
    t.string   "url"
    t.string   "phone_no"
    t.string   "website"
    t.string   "dna_excerpt"
    t.string   "dna_neighbourhood"
    t.string   "dna_atmosphere"
    t.string   "dna_pricepoint"
    t.string   "dna_category"
    t.string   "dna_dresscode"
    t.string   "dna_pictures"
    t.string   "dna_review"
    t.integer  "dna_rating_conversation"
    t.integer  "dna_rating_convenience"
    t.integer  "dna_rating_comfort"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "external_id"
    t.boolean  "deleted"
  end

  create_table "cart_items", :force => true do |t|
    t.integer  "business_id"
    t.integer  "datecart_id"
    t.string   "venue_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "event_id"
  end

  create_table "categories", :force => true do |t|
    t.string   "parent_name"
    t.string   "name"
    t.string   "display_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "datecarts", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",       :default => "My Date"
    t.string   "datetime",   :default => ""
    t.string   "notes",      :default => "Make it special!"
  end

  create_table "events", :force => true do |t|
    t.string "title"
    t.string "url"
    t.string "photo_url"
    t.string "start_time"
    t.string "end_time"
    t.string "venue_name"
    t.string "venue_address"
    t.string "city_name"
    t.string "region_name"
    t.string "postal_code"
    t.string "latitude"
    t.string "longitude"
    t.string "eventid"
  end

  create_table "farmed_infos", :force => true do |t|
    t.string   "neighbourhood"
    t.integer  "offset"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "categories"
    t.integer  "loaded"
  end

  create_table "neighbourhoods", :force => true do |t|
    t.string   "district"
    t.string   "district_subsection"
    t.string   "neighbourhood"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profiles", :force => true do |t|
    t.integer  "user_id"
    t.string   "avatar_url"
    t.date     "anniversary"
    t.string   "about_me"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "profiles", ["user_id"], :name => "index_profiles_on_user_id"

  create_table "relationships", :force => true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relationships", ["followed_id"], :name => "index_relationships_on_followed_id"
  add_index "relationships", ["follower_id"], :name => "index_relationships_on_follower_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                             :default => "", :null => false
    t.string   "encrypted_password", :limit => 128, :default => "", :null => false
    t.integer  "sign_in_count",                     :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",                   :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.string   "first_name"
    t.string   "last_name"
    t.date     "birthday"
    t.string   "postal_code"
    t.string   "gender"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

  create_table "wizards", :force => true do |t|
    t.string   "venue"
    t.string   "location"
    t.integer  "priceRange"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
