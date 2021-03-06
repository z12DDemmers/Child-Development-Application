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

ActiveRecord::Schema.define(version: 20151207191920) do

  create_table "answers", force: :cascade do |t|
    t.boolean "response"
    t.float   "age_achieved"
    t.integer "question_id"
    t.integer "child_id"
  end

  add_index "answers", ["child_id"], name: "index_answers_on_child_id"
  add_index "answers", ["question_id"], name: "index_answers_on_question_id"

  create_table "children", force: :cascade do |t|
    t.string  "name"
    t.integer "age"
    t.integer "user_id"
    t.float   "developmental_age"
    t.float   "prone_score"
    t.float   "supine_score"
    t.float   "responses_score"
    t.float   "reflexes_score"
    t.float   "sitting_score"
    t.float   "standing_score"
    t.float   "mobility_score"
    t.float   "throwing_and_catching_score"
    t.float   "gross_motor_score"
    t.float   "cognitive_score"
    t.float   "development_of_symbolic_play_score"
    t.float   "gestural_imitation_score"
    t.float   "sound_awareness_score"
    t.float   "object_permanence_score"
    t.float   "means_end_score"
    t.float   "cause_effect_score"
    t.float   "spatial_relationships_score"
    t.float   "number_sense_score"
    t.float   "classification_score"
    t.float   "attention_maintanence_score"
    t.float   "receptive_language_score"
    t.float   "objects_events_and_relationships_score"
    t.float   "body_parts_score"
    t.float   "understanding_directions_score"
  end

  add_index "children", ["user_id"], name: "index_children_on_user_id"

  create_table "domains", force: :cascade do |t|
    t.text     "domain"
    t.text     "domain_description"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "domains", ["domain"], name: "index_domains_on_domain", unique: true

  create_table "questions", force: :cascade do |t|
    t.text     "question"
    t.text     "description"
    t.float    "minimum_age_to_ask"
    t.float    "maximum_age_to_ask"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "subdomain_id"
    t.text     "exercise"
  end

  add_index "questions", ["question"], name: "index_questions_on_question", unique: true
  add_index "questions", ["subdomain_id"], name: "index_questions_on_subdomain_id"

  create_table "subdomains", force: :cascade do |t|
    t.text     "subdomain"
    t.text     "subdomain_description"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "domain_id"
  end

  add_index "subdomains", ["domain_id"], name: "index_subdomains_on_domain_id"
  add_index "subdomains", ["subdomain"], name: "index_subdomains_on_subdomain", unique: true

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.string "password_digest"
  end

end
