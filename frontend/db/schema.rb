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

ActiveRecord::Schema[8.1].define(version: 2026_09_24_175809) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "unaccent"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "attachment_aasm_states", ["created", "processed"]
  create_enum "attachment_types", ["DataBlockFile", "AudioFile", "VideoFile", "ImageFile", "TextFile", "PdfFile", "CsvFile", "ExcelFile"]
  create_enum "daily_event_types", ["click", "render", "upload"]
  create_enum "event_types", ["click", "render", "upload"]
  create_enum "folder_aasm_states", ["created", "published", "archived"]
  create_enum "url_daily_event_types", ["click", "render", "upload"]

  create_table "accounts", force: :cascade do |t|
    t.uuid "uuid", null: false
    t.string "name", null: false
    t.string "address", null: false
    t.string "time_zone", default: "UTC", null: false
    t.string "data_url"
    t.string "account_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.index ["account_code"], name: "index_accounts_on_account_code", unique: true
    t.index ["data_url"], name: "index_accounts_on_data_url", unique: true
    t.index ["uuid"], name: "index_accounts_on_uuid", unique: true
  end

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

  create_table "attachments", force: :cascade do |t|
    t.bigint "folder_id"
    t.bigint "account_id"
    t.datetime "file_created_at", null: false
    t.datetime "file_updated_at", null: false
    t.uuid "upload_uuid"
    t.enum "aasm_state", default: "created", null: false, enum_type: "attachment_aasm_states"
    t.enum "type", null: false, enum_type: "attachment_types"
    t.string "data_url"
    t.json "parameters"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.index ["account_id"], name: "index_attachments_on_account_id"
    t.index ["data_url"], name: "index_attachments_on_data_url", unique: true
    t.index ["folder_id"], name: "index_attachments_on_folder_id"
  end

  create_table "daily_events", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.date "date", null: false
    t.enum "event_type", null: false, enum_type: "daily_event_types"
    t.bigint "value", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "event_type", "date"], name: "events_account_id_event_type_and_date", unique: true
    t.index ["account_id"], name: "index_daily_events_on_account_id"
  end

  create_table "events", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "url", null: false
    t.enum "event_type", null: false, enum_type: "event_types"
    t.json "parameters", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_events_on_account_id"
  end

  create_table "folders", force: :cascade do |t|
    t.string "name"
    t.uuid "upload_uuid", null: false
    t.jsonb "tags", default: {}, null: false
    t.enum "aasm_state", default: "created", null: false, enum_type: "folder_aasm_states"
    t.string "data_url"
    t.datetime "published_at"
    t.datetime "published_from"
    t.datetime "published_to"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.index ["data_url"], name: "index_folders_on_data_url", unique: true
  end

  create_table "html_files", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "filename", null: false
    t.string "data", null: false
    t.string "mime_type", null: false
    t.string "theme", null: false
    t.boolean "default", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_html_files_on_account_id"
  end

  create_table "links", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "name"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_links_on_account_id"
  end

  create_table "meta_tags", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "name"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_meta_tags_on_account_id"
  end

  create_table "playlists", force: :cascade do |t|
    t.integer "media_id", null: false
    t.string "media_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "register_users", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "company_name"
    t.string "email_address", null: false
    t.string "address", null: false
    t.string "postal_code", null: false
    t.string "city", null: false
    t.string "country", null: false
    t.string "password_digest", null: false
    t.string "reset_password_token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "ts_files", force: :cascade do |t|
    t.integer "media_id", null: false
    t.string "media_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "uploads", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.uuid "uuid", null: false
    t.uuid "upload_file_uuid"
    t.string "file_path", null: false
    t.string "mime_type", null: false
    t.datetime "file_created_at", null: false
    t.datetime "file_updated_at", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.index ["user_id"], name: "index_uploads_on_user_id"
    t.index ["uuid"], name: "index_uploads_on_uuid", unique: true
  end

  create_table "url_daily_events", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.date "date", null: false
    t.enum "event_type", null: false, enum_type: "daily_event_types"
    t.string "url"
    t.bigint "value", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "url", "event_type", "date"], name: "url_daily_events_account_id_url_event_type_and_date", unique: true
    t.index ["account_id"], name: "index_url_daily_events_on_account_id"
  end

  create_table "users", force: :cascade do |t|
    t.uuid "account_uuid", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "auth_token"
    t.string "password_digest", null: false
    t.string "reset_password_token", null: false
    t.string "email_address", null: false
    t.datetime "email_address_validated_at"
    t.boolean "deliver_notifications_sign_in", default: false, null: false
    t.boolean "deliver_notifications_account_update", default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.json "object"
    t.json "object_changes"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "attachments", "accounts"
  add_foreign_key "attachments", "folders"
  add_foreign_key "daily_events", "accounts"
  add_foreign_key "events", "accounts"
  add_foreign_key "html_files", "accounts"
  add_foreign_key "links", "accounts"
  add_foreign_key "meta_tags", "accounts"
  add_foreign_key "sessions", "users"
  add_foreign_key "uploads", "users"
  add_foreign_key "url_daily_events", "accounts"
end
