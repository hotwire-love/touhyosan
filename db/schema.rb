# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_02_13_081048) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "candidates", force: :cascade do |t|
    t.string "title"
    t.bigint "pre_poll_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pre_poll_id"], name: "index_candidates_on_pre_poll_id"
  end

  create_table "choicecandidates", force: :cascade do |t|
    t.string "title"
    t.bigint "candidate_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["candidate_id"], name: "index_choicecandidates_on_candidate_id"
  end

  create_table "choiceitems", force: :cascade do |t|
    t.string "title"
    t.boolean "accepted"
    t.bigint "proposal_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["proposal_id"], name: "index_choiceitems_on_proposal_id"
  end

  create_table "choices", force: :cascade do |t|
    t.string "title", null: false
    t.bigint "poll_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["poll_id"], name: "index_choices_on_poll_id"
  end

  create_table "polls", force: :cascade do |t|
    t.string "title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pre_polls", force: :cascade do |t|
    t.string "title"
    t.string "editor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "proposals", force: :cascade do |t|
    t.string "user_name"
    t.string "content"
    t.bigint "pre_poll_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pre_poll_id"], name: "index_proposals_on_pre_poll_id"
  end

  create_table "vote_details", force: :cascade do |t|
    t.bigint "vote_id", null: false
    t.bigint "choice_id", null: false
    t.integer "status", default: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.index ["choice_id"], name: "index_vote_details_on_choice_id"
    t.index ["vote_id"], name: "index_vote_details_on_vote_id"
  end

  create_table "votes", force: :cascade do |t|
    t.string "user_name", null: false
    t.text "comment", default: "", null: false
    t.bigint "poll_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["poll_id"], name: "index_votes_on_poll_id"
  end

  add_foreign_key "candidates", "pre_polls"
  add_foreign_key "choicecandidates", "candidates"
  add_foreign_key "choiceitems", "proposals"
  add_foreign_key "choices", "polls"
  add_foreign_key "proposals", "pre_polls"
  add_foreign_key "vote_details", "choices"
  add_foreign_key "vote_details", "votes"
  add_foreign_key "votes", "polls"
end
