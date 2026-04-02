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

ActiveRecord::Schema[7.1].define(version: 2026_04_02_181510) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_trgm"
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
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

  create_table "drug_pages", force: :cascade do |t|
    t.bigint "drug_id", null: false
    t.string "slug", null: false
    t.text "educational_content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["drug_id"], name: "index_drug_pages_on_drug_id", unique: true
    t.index ["slug"], name: "index_drug_pages_on_slug", unique: true
  end

  create_table "drugs", force: :cascade do |t|
    t.string "name", null: false
    t.string "active_ingredient", null: false
    t.string "form"
    t.string "dosage"
    t.boolean "requires_prescription", default: false, null: false
    t.string "therapeutic_group"
    t.string "via"
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "drug_type", default: "generico_intercambiable", null: false
    t.index ["active_ingredient"], name: "index_drugs_on_active_ingredient"
    t.index ["active_ingredient"], name: "index_drugs_on_active_ingredient_trgm", opclass: :gin_trgm_ops, using: :gin
    t.index ["drug_type"], name: "index_drugs_on_drug_type"
    t.index ["name"], name: "index_drugs_on_name", opclass: :gin_trgm_ops, using: :gin
    t.index ["slug"], name: "index_drugs_on_slug", unique: true
  end

  create_table "generic_equivalents", force: :cascade do |t|
    t.bigint "drug_id", null: false
    t.integer "reference_drug_id", null: false
    t.string "cofepris_registration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["drug_id", "reference_drug_id"], name: "index_generic_equivalents_on_drug_id_and_reference_drug_id", unique: true
    t.index ["drug_id"], name: "index_generic_equivalents_on_drug_id"
    t.index ["reference_drug_id"], name: "index_generic_equivalents_on_reference_drug_id"
  end

  create_table "pharmacies", force: :cascade do |t|
    t.string "name", null: false
    t.string "kind", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_pharmacies_on_name"
  end

  create_table "price_entries", force: :cascade do |t|
    t.bigint "drug_id", null: false
    t.bigint "pharmacy_id", null: false
    t.decimal "price_per_box", precision: 10, scale: 2, null: false
    t.integer "units_per_box", null: false
    t.decimal "price_per_unit", precision: 10, scale: 2
    t.string "promotion"
    t.date "promotion_expiry"
    t.boolean "in_stock", default: true, null: false
    t.boolean "home_delivery", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["drug_id", "pharmacy_id"], name: "index_price_entries_on_drug_id_and_pharmacy_id"
    t.index ["drug_id"], name: "index_price_entries_on_drug_id"
    t.index ["pharmacy_id"], name: "index_price_entries_on_pharmacy_id"
  end

  create_table "user_medications", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "drug_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["drug_id"], name: "index_user_medications_on_drug_id"
    t.index ["user_id", "drug_id"], name: "index_user_medications_on_user_id_and_drug_id", unique: true
    t.index ["user_id"], name: "index_user_medications_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "drug_pages", "drugs"
  add_foreign_key "generic_equivalents", "drugs"
  add_foreign_key "generic_equivalents", "drugs", column: "reference_drug_id"
  add_foreign_key "price_entries", "drugs"
  add_foreign_key "price_entries", "pharmacies"
  add_foreign_key "user_medications", "drugs"
  add_foreign_key "user_medications", "users"
end
