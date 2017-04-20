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

ActiveRecord::Schema.define(version: 20170420205842) do

  create_table "contents", force: :cascade do |t|
    t.integer  "entry_id"
    t.text     "html"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "entries", force: :cascade do |t|
    t.integer  "source_id"
    t.string   "title"
    t.string   "url"
    t.boolean  "fav"
    t.boolean  "read"
    t.datetime "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sources", force: :cascade do |t|
    t.string   "name"
    t.string   "url"
    t.datetime "last_update"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "favicon"
    t.string   "html_url"
  end

  create_table "sources_tags", id: false, force: :cascade do |t|
    t.integer "source_id"
    t.integer "tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.string   "color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
