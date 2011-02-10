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

ActiveRecord::Schema.define(:version => 20110125021326) do

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
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

  create_table "venues", :force => true do |t|
    t.string   "venue_type"
    t.string   "venue_logo"
    t.string   "venue_name"
    t.string   "venue_address1"
    t.string   "venue_city"
    t.string   "venue_prov"
    t.string   "venue_postal"
    t.string   "venue_country"
    t.string   "venue_phone"
    t.string   "venue_website"
    t.string   "venue_dna_neighbourhood"
    t.string   "venue_dna_atmosphere"
    t.string   "venue_dna_pricepoint"
    t.string   "venue_dna_foodcategory"
    t.string   "venue_dna_dresscode"
    t.string   "venue_dna_pictures"
    t.string   "venue_post_title"
    t.string   "venue_dna_review"
    t.integer  "venue_dna_conversation"
    t.integer  "venue_dna_convenience"
    t.integer  "venue_dna_comfort"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "wizards", :force => true do |t|
    t.string   "venue"
    t.string   "location"
    t.integer  "priceRange"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
