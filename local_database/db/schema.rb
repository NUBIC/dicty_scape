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

ActiveRecord::Schema.define(version: 20130722150536) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "annotations", force: true do |t|
    t.string "go_id"
    t.string "annotation_name"
  end

  create_table "gene_annotations", force: true do |t|
    t.string  "db_object_symbol"
    t.string  "go_id"
    t.string  "evidence_code"
    t.string  "aspect"
    t.string  "reference"
    t.integer "aspect_num"
    t.string  "color_code"
  end

  create_table "genes", force: true do |t|
    t.string "db_object_id"
    t.string "db_object_symbol"
    t.string "db_object_name"
    t.string "db_object_synonym"
  end

  create_table "relationships", force: true do |t|
    t.string "go_id"
    t.string "parent_go_id"
  end

end
