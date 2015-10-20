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

ActiveRecord::Schema.define(version: 20150927030310) do

  create_table "domains", force: :cascade do |t|
    t.text     "domain"
    t.text     "domain_description"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "questions", force: :cascade do |t|
    t.text     "question"
    t.text     "description"
    t.float    "minimum_age_to_ask"
    t.float    "maximum_age_to_ask"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "subdomain_id"
  end

  add_index "questions", ["subdomain_id"], name: "index_questions_on_subdomain_id"

  create_table "subdomains", force: :cascade do |t|
    t.text     "subdomain"
    t.text     "subdomain_description"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "domain_id"
  end

  add_index "subdomains", ["domain_id"], name: "index_subdomains_on_domain_id"

end
