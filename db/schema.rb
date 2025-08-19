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

ActiveRecord::Schema[8.0].define(version: 2025_06_18_061020) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "carbon_emissions", force: :cascade do |t|
    t.string "item_name"
    t.string "category"
    t.string "period_range"
    t.string "production_area"
    t.decimal "carbon_emission_value"
    t.string "unit"
    t.datetime "announcement_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "material_usages", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "carbon_emission_id", null: false
    t.decimal "quantity"
    t.string "stage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["carbon_emission_id"], name: "index_material_usages_on_carbon_emission_id"
    t.index ["project_id"], name: "index_material_usages_on_project_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "project_name"
    t.string "project_type"
    t.string "location"
    t.decimal "area"
    t.integer "floors_above"
    t.integer "floors_below"
    t.decimal "excavation_depth"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "area_unit"
    t.string "depth_unit"
    t.integer "above_ground_floors"
    t.string "above_floor_unit"
    t.integer "below_ground_floors"
    t.string "below_floor_unit"
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_projects_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "organization"
    t.string "contact_name"
    t.string "username"
    t.boolean "approved"
    t.string "role"
    t.boolean "admin"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "material_usages", "carbon_emissions"
  add_foreign_key "material_usages", "projects"
  add_foreign_key "projects", "users"
end
