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

ActiveRecord::Schema.define(version: 20161124151727) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ad_items", force: :cascade do |t|
    t.integer  "ad_id"
    t.integer  "item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ad_items", ["ad_id"], name: "index_ad_items_on_ad_id", using: :btree
  add_index "ad_items", ["item_id"], name: "index_ad_items_on_item_id", using: :btree

  create_table "ad_locations", force: :cascade do |t|
    t.integer  "ad_id"
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ad_locations", ["ad_id"], name: "index_ad_locations_on_ad_id", using: :btree
  add_index "ad_locations", ["location_id"], name: "index_ad_locations_on_location_id", using: :btree

  create_table "ad_translations", force: :cascade do |t|
    t.integer  "ad_id",                   null: false
    t.string   "locale",      limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title",       limit: 255
    t.text     "description"
  end

  add_index "ad_translations", ["ad_id"], name: "index_ad_translations_on_ad_id", using: :btree
  add_index "ad_translations", ["locale"], name: "index_ad_translations_on_locale", using: :btree

  create_table "ad_users", force: :cascade do |t|
    t.integer  "ad_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ad_users", ["ad_id"], name: "index_ad_users_on_ad_id", using: :btree
  add_index "ad_users", ["user_id"], name: "index_ad_users_on_user_id", using: :btree

  create_table "ads", force: :cascade do |t|
    t.string   "title",           limit: 255
    t.text     "description"
    t.integer  "location_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "username_used"
    t.boolean  "giving"
    t.date     "expire_date"
    t.string   "image",           limit: 255
    t.string   "anon_name",       limit: 255
    t.string   "anon_email",      limit: 255
    t.string   "benef_age_group", limit: 255
    t.boolean  "is_published"
    t.string   "legal_form",      limit: 255
    t.string   "anon_email_2",    limit: 255
    t.string   "anon_email_3",    limit: 255
    t.jsonb    "marker_info",                 default: {}
  end

  add_index "ads", ["location_id"], name: "index_ads_on_location_id", using: :btree
  add_index "ads", ["user_id"], name: "index_ads_on_user_id", using: :btree

  create_table "ads_categories", force: :cascade do |t|
    t.integer  "ad_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ads_categories", ["ad_id"], name: "index_ads_categories_on_ad_id", using: :btree
  add_index "ads_categories", ["category_id"], name: "index_ads_categories_on_category_id", using: :btree

  create_table "areas", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "latitude",               precision: 8, scale: 5
    t.decimal  "longitude",              precision: 8, scale: 5
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "icon",         limit: 255
    t.string   "marker_color", limit: 255
  end

  create_table "category_translations", force: :cascade do |t|
    t.integer  "category_id",             null: false
    t.string   "locale",      limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",        limit: 255
    t.text     "description"
  end

  add_index "category_translations", ["category_id"], name: "index_category_translations_on_category_id", using: :btree
  add_index "category_translations", ["locale"], name: "index_category_translations_on_locale", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",               default: 0, null: false
    t.integer  "attempts",               default: 0, null: false
    t.text     "handler",                            null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "district_translations", force: :cascade do |t|
    t.integer  "district_id",             null: false
    t.string   "locale",      limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",        limit: 255
  end

  add_index "district_translations", ["district_id"], name: "index_district_translations_on_district_id", using: :btree
  add_index "district_translations", ["locale"], name: "index_district_translations_on_locale", using: :btree

  create_table "faq_translations", force: :cascade do |t|
    t.integer  "faq_id",                 null: false
    t.string   "locale",     limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "question"
    t.text     "answer"
  end

  add_index "faq_translations", ["faq_id"], name: "index_faq_translations_on_faq_id", using: :btree
  add_index "faq_translations", ["locale"], name: "index_faq_translations_on_locale", using: :btree

  create_table "faqs", force: :cascade do |t|
    t.string   "question",   limit: 255
    t.text     "answer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "item_translations", force: :cascade do |t|
    t.integer  "item_id",                 null: false
    t.string   "locale",      limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",        limit: 255
    t.string   "description", limit: 255
  end

  add_index "item_translations", ["item_id"], name: "index_item_translations_on_item_id", using: :btree
  add_index "item_translations", ["locale"], name: "index_item_translations_on_locale", using: :btree

  create_table "items", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "description", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_id"
  end

  add_index "items", ["category_id"], name: "index_items_on_category_id", using: :btree

  create_table "location_translations", force: :cascade do |t|
    t.integer  "location_id",             null: false
    t.string   "locale",      limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",        limit: 255
    t.string   "address",     limit: 255
    t.string   "postal_code", limit: 255
    t.string   "province",    limit: 255
    t.string   "city",        limit: 255
    t.text     "description"
    t.string   "block_unit"
    t.string   "village"
  end

  add_index "location_translations", ["locale"], name: "index_location_translations_on_locale", using: :btree
  add_index "location_translations", ["location_id"], name: "index_location_translations_on_location_id", using: :btree

  create_table "locations", force: :cascade do |t|
    t.string   "name",               limit: 255
    t.string   "address",            limit: 255
    t.string   "postal_code",        limit: 255
    t.string   "province",           limit: 255
    t.string   "city",               limit: 255
    t.string   "phone_number",       limit: 255
    t.string   "website",            limit: 255
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "street_number",      limit: 255
    t.decimal  "latitude",                       precision: 7, scale: 5
    t.decimal  "longitude",                      precision: 8, scale: 5
    t.integer  "user_id"
    t.integer  "area_id"
    t.string   "facebook",           limit: 255
    t.string   "add_phone_number",   limit: 255
    t.string   "add_phone_number_2", limit: 255
    t.string   "block_unit"
    t.string   "village"
  end

  add_index "locations", ["area_id"], name: "index_locations_on_area_id", using: :btree
  add_index "locations", ["user_id"], name: "index_locations_on_user_id", using: :btree

  create_table "map_tiles", force: :cascade do |t|
    t.string   "name"
    t.string   "tile_url"
    t.string   "attribution"
    t.string   "api_key"
    t.string   "map_name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "setting_translations", force: :cascade do |t|
    t.integer  "setting_id",             null: false
    t.string   "locale",     limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "value"
  end

  add_index "setting_translations", ["locale"], name: "index_setting_translations_on_locale", using: :btree
  add_index "setting_translations", ["setting_id"], name: "index_setting_translations_on_setting_id", using: :btree

  create_table "settings", force: :cascade do |t|
    t.string   "key",        limit: 255
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "simple_captcha_data", force: :cascade do |t|
    t.string   "key",        limit: 40
    t.string   "value",      limit: 6
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "simple_captcha_data", ["key"], name: "idx_key", using: :btree

  create_table "todos", force: :cascade do |t|
    t.string   "description"
    t.string   "condition"
    t.string   "alert"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "user_translations", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.string   "locale",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "first_name"
    t.string   "last_name"
  end

  add_index "user_translations", ["locale"], name: "index_user_translations_on_locale", using: :btree
  add_index "user_translations", ["user_id"], name: "index_user_translations_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255,                 null: false
    t.string   "encrypted_password",     limit: 255,                 null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.integer  "role"
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
    t.string   "username",               limit: 255
    t.boolean  "is_service_provider"
    t.boolean  "has_agreed_to_tos",                  default: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
