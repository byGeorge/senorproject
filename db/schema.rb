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

ActiveRecord::Schema.define(version: 20160329043524) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "appearances", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "blurbs", force: :cascade do |t|
    t.string  "text",              limit: 1028
    t.integer "lvl_requirement"
    t.string  "class_requirement", limit: 16
    t.string  "race_requirement"
    t.string  "type_requirement"
  end

  create_table "c_classes", force: :cascade do |t|
    t.string "name", limit: 30
  end

  create_table "characters", force: :cascade do |t|
    t.integer "userid"
    t.string  "name",            limit: 60
    t.integer "level"
    t.integer "race"
    t.integer "strength"
    t.integer "dexterity"
    t.integer "constitution"
    t.integer "intelligence"
    t.integer "wisdom"
    t.integer "charisma"
    t.integer "acrobatics"
    t.integer "animal_handling"
    t.integer "arcana"
    t.integer "athletics"
    t.integer "deception"
    t.integer "history"
    t.integer "insight"
    t.integer "intimidation"
    t.integer "investigation"
    t.integer "medicine"
    t.integer "nature"
    t.integer "perception"
    t.integer "performance"
    t.integer "persuasion"
    t.integer "religion"
    t.integer "sleight_of_hand"
    t.integer "stealth"
    t.integer "survival"
    t.integer "class"
  end

  create_table "dwarf_names", force: :cascade do |t|
    t.string "fname",     limit: 30
    t.string "clan_name", limit: 30
    t.string "gender",    limit: 1
  end

  add_index "dwarf_names", ["clan_name"], name: "dwarf_names_clan_name_key", unique: true, using: :btree
  add_index "dwarf_names", ["fname"], name: "dwarf_names_fname_key", unique: true, using: :btree

  create_table "elf_names", force: :cascade do |t|
    t.string "name", limit: 30
  end

  add_index "elf_names", ["name"], name: "elf_names_name_key", unique: true, using: :btree

  create_table "elf_syllables", force: :cascade do |t|
    t.string "syllable", limit: 3, null: false
  end

  add_index "elf_syllables", ["syllable"], name: "elf_syllables_syllable_key", unique: true, using: :btree

  create_table "human_names", force: :cascade do |t|
    t.string "first_name", limit: 30
    t.string "last_name",  limit: 30
    t.string "nickname",   limit: 30
    t.string "gender",     limit: 1
  end

  add_index "human_names", ["first_name", "last_name", "nickname"], name: "human_names_first_name_last_name_nickname_key", unique: true, using: :btree

  create_table "races", force: :cascade do |t|
    t.string "name", limit: 10
  end

  create_table "spells", force: :cascade do |t|
    t.integer "level"
    t.string  "spell",  limit: 50
    t.string  "cclass", limit: 32
  end

  create_table "users", force: :cascade do |t|
    t.string "name", limit: 20
  end

  add_index "users", ["name"], name: "users_name_key", unique: true, using: :btree

  add_foreign_key "characters", "c_classes", column: "class", name: "characters_class_fkey"
  add_foreign_key "characters", "races", column: "race", name: "characters_race_fkey"
  add_foreign_key "characters", "users", column: "userid", name: "characters_userid_fkey"
end
