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

ActiveRecord::Schema.define(version: 2021_11_21_172027) do

  create_table "collections", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "owner_id"
    t.index ["owner_id"], name: "index_collections_on_owner_id"
  end

  create_table "collections_images", id: false, force: :cascade do |t|
    t.integer "collection_id", null: false
    t.integer "image_id", null: false
  end

  create_table "collections_tags", id: false, force: :cascade do |t|
    t.integer "collection_id", null: false
    t.integer "tag_id", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.text "text"
    t.string "username"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "rating_id"
    t.integer "image_id", null: false
    t.index ["image_id"], name: "index_comments_on_image_id"
    t.index ["rating_id"], name: "index_comments_on_rating_id"
  end

  create_table "images", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "owner_id"
    t.index ["owner_id"], name: "index_images_on_owner_id"
  end

  create_table "images_tags", id: false, force: :cascade do |t|
    t.integer "tag_id", null: false
    t.integer "image_id", null: false
  end

  create_table "ratings", force: :cascade do |t|
    t.float "rating"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "rateable_type", null: false
    t.integer "rateable_id", null: false
    t.index ["rateable_type", "rateable_id"], name: "index_ratings_on_rateable"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.boolean "admin"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "collections", "users", column: "owner_id"
  add_foreign_key "comments", "images"
  add_foreign_key "comments", "ratings"
  add_foreign_key "images", "users", column: "owner_id"
end
