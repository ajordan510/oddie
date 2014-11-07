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

ActiveRecord::Schema.define(version: 20141107023046) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "splash_users", force: true do |t|
    t.text     "email"
    t.text     "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.text     "email"
    t.text     "nickname"
    t.text     "age"
    t.string   "photo_name"
    t.text     "performer"
    t.text     "genre_comedian"
    t.text     "genre_singer"
    t.text     "genre_musician"
    t.text     "genre_dancer"
    t.text     "genre_actor"
    t.text     "genre_speaker"
    t.text     "genre_DJ"
    t.text     "genre_other"
    t.text     "description"
    t.text     "terms_conditions"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.float    "salt"
  end

end
