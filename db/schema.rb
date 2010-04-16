# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100416090912) do

  create_table "films", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "team_name"
    t.text     "editorial_notes"
    t.string   "unique_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "movie_file_name"
    t.string   "movie_content_type"
    t.integer  "movie_file_size"
    t.datetime "movie_updated_at"
    t.string   "processed_movie_file_name"
    t.string   "processed_movie_content_type"
    t.integer  "processed_movie_file_size"
    t.datetime "processed_movie_updated_at"
    t.string   "thumbnail_file_name"
    t.string   "thumbnail_content_type"
    t.integer  "thumbnail_file_size"
    t.datetime "thumbnail_updated_at"
    t.integer  "duration"
    t.string   "music_status"
    t.string   "video_status"
    t.string   "stills_status"
    t.string   "safety_status"
    t.string   "science_status"
    t.string   "aspect"
    t.boolean  "published"
    t.integer  "user_id"
    t.text     "team_info"
    t.string   "license"
    t.date     "production_date"
    t.boolean  "submit_by_post"
    t.boolean  "agreements_posted"
    t.text     "others_material"
  end

  add_index "films", ["user_id"], :name => "index_films_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "name"
    t.string   "email"
    t.string   "institution"
    t.text     "feedback"
    t.boolean  "administrator",                           :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",                                   :default => "inactive"
    t.datetime "key_timestamp"
    t.string   "postcode"
    t.string   "how_did_you_hear_about_us"
    t.string   "first_time"
    t.float    "lat"
    t.float    "lng"
  end

  add_index "users", ["state"], :name => "index_users_on_state"

end
