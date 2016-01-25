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

ActiveRecord::Schema.define(version: 0) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "dwarf_names", primary_key: "NID", force: :cascade do |t|
    t.string "name", limit: 30
  end

  add_index "dwarf_names", ["name"], name: "dwarf_names_name_key", unique: true, using: :btree

  create_table "elf_names", primary_key: "NID", force: :cascade do |t|
    t.string "name", limit: 30
  end

  add_index "elf_names", ["name"], name: "elf_names_name_key", unique: true, using: :btree

  create_table "elf_syllables", primary_key: "SID", force: :cascade do |t|
    t.string "syllable", limit: 3, null: false
  end

  add_index "elf_syllables", ["syllable"], name: "elf_syllables_syllable_key", unique: true, using: :btree

  create_table "human_names", primary_key: "NID", force: :cascade do |t|
    t.string "first_name", limit: 30
    t.string "last_name",  limit: 30
    t.string "nickname",   limit: 30
    t.string "Gender",     limit: 1
  end

  add_index "human_names", ["first_name", "last_name", "nickname"], name: "human_names_first_name_last_name_nickname_key", unique: true, using: :btree

  create_table "races", primary_key: "rid", force: :cascade do |t|
    t.string "name", limit: 10
  end

  create_table "users", primary_key: "uid", force: :cascade do |t|
    t.string "name", limit: 20
  end

  add_index "users", ["name"], name: "users_name_key", unique: true, using: :btree

end
