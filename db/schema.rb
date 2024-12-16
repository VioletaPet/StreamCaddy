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

ActiveRecord::Schema[7.1].define(version: 2024_12_16_115827) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "actors", force: :cascade do |t|
    t.string "name"
    t.text "bio"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "api_id"
    t.index ["api_id"], name: "index_actors_on_api_id", unique: true
  end

  create_table "episodes", force: :cascade do |t|
    t.string "name"
    t.integer "number"
    t.text "synopsis"
    t.bigint "season_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["season_id"], name: "index_episodes_on_season_id"
  end

  create_table "genres", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "api_id"
  end

  create_table "media", force: :cascade do |t|
    t.string "title"
    t.string "category"
    t.text "synopsis"
    t.string "creator"
    t.integer "api_id"
    t.date "release_date"
    t.string "run_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "average_rating"
  end

  create_table "media_actors", force: :cascade do |t|
    t.bigint "actor_id", null: false
    t.bigint "media_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "character"
    t.index ["actor_id"], name: "index_media_actors_on_actor_id"
    t.index ["media_id"], name: "index_media_actors_on_media_id"
  end

  create_table "media_genres", force: :cascade do |t|
    t.bigint "media_id", null: false
    t.bigint "genre_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["genre_id"], name: "index_media_genres_on_genre_id"
    t.index ["media_id"], name: "index_media_genres_on_media_id"
  end

  create_table "media_watch_providers", force: :cascade do |t|
    t.bigint "watch_provider_id", null: false
    t.bigint "media_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "flatrate"
    t.boolean "buy"
    t.boolean "rent"
    t.index ["media_id"], name: "index_media_watch_providers_on_media_id"
    t.index ["watch_provider_id"], name: "index_media_watch_providers_on_watch_provider_id"
  end

  create_table "progress_trackers", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.boolean "watched"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_progress_trackers_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.text "content"
    t.bigint "media_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "rating"
    t.index ["media_id"], name: "index_reviews_on_media_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "seasons", force: :cascade do |t|
    t.bigint "media_id", null: false
    t.integer "number"
    t.integer "no_of_episodes"
    t.text "synopsis"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["media_id"], name: "index_seasons_on_media_id"
  end

  create_table "user_providers", force: :cascade do |t|
    t.bigint "watch_provider_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_providers_on_user_id"
    t.index ["watch_provider_id"], name: "index_user_providers_on_watch_provider_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.string "first_name"
    t.string "last_name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "watch_providers", force: :cascade do |t|
    t.string "name"
    t.integer "api_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "watchlist_media", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "media_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["media_id"], name: "index_watchlist_media_on_media_id"
    t.index ["user_id"], name: "index_watchlist_media_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "episodes", "seasons"
  add_foreign_key "media_actors", "actors"
  add_foreign_key "media_actors", "media", column: "media_id"
  add_foreign_key "media_genres", "genres"
  add_foreign_key "media_genres", "media", column: "media_id"
  add_foreign_key "media_watch_providers", "media", column: "media_id"
  add_foreign_key "media_watch_providers", "watch_providers"
  add_foreign_key "progress_trackers", "users"
  add_foreign_key "reviews", "media", column: "media_id"
  add_foreign_key "reviews", "users"
  add_foreign_key "seasons", "media", column: "media_id"
  add_foreign_key "user_providers", "users"
  add_foreign_key "user_providers", "watch_providers"
  add_foreign_key "watchlist_media", "media", column: "media_id"
  add_foreign_key "watchlist_media", "users"
end
