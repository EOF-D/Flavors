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

ActiveRecord::Schema[7.1].define(version: 2024_03_15_000642) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ingredients", id: :serial, force: :cascade do |t|
    t.uuid "recipe_id", null: false
    t.text "name", null: false
    t.text "quantity"
    t.text "unit"
    t.text "preparation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "recipe_times", force: :cascade do |t|
    t.uuid "recipe_id", null: false
    t.text "preparation"
    t.text "cooking"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "recipes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "url"
    t.text "name", null: false
    t.text "author"
    t.integer "ratings"
    t.text "description"
    t.integer "serves"
    t.text "difficult"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "steps", id: :serial, force: :cascade do |t|
    t.uuid "recipe_id", null: false
    t.integer "step_number", null: false
    t.text "step_text", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "ingredients", "recipes"
  add_foreign_key "recipe_times", "recipes"
  add_foreign_key "steps", "recipes"
end
