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

ActiveRecord::Schema.define(version: 20170525051911) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "areas", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "latitude",               precision: 8, scale: 5
    t.decimal  "longitude",              precision: 8, scale: 5
  end

  create_table "assets", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id"
    t.integer  "owner_type"
    t.string   "image"
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "icon",         limit: 255
    t.string   "marker_color", limit: 255
  end

  create_table "categories_posts", force: :cascade do |t|
    t.integer  "post_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories_posts", ["category_id"], name: "index_categories_posts_on_category_id", using: :btree
  add_index "categories_posts", ["post_id"], name: "index_categories_posts_on_post_id", using: :btree

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

  create_table "favorite_places", id: false, force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "place_id",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "favorite_places", ["place_id", "user_id"], name: "favorite_places_unique", unique: true, using: :btree

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
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "map_georgian_name"
    t.string   "map_english_name"
  end

  create_table "page_content_translations", force: :cascade do |t|
    t.integer  "page_content_id", null: false
    t.string   "locale",          null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "title"
    t.text     "content"
  end

  add_index "page_content_translations", ["locale"], name: "index_page_content_translations_on_locale", using: :btree
  add_index "page_content_translations", ["page_content_id"], name: "index_page_content_translations_on_page_content_id", using: :btree

  create_table "page_contents", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "page_contents", ["name"], name: "index_page_contents_on_name", using: :btree

  create_table "place_ownerships", force: :cascade do |t|
    t.integer  "place_id",                 null: false
    t.integer  "user_id",                  null: false
    t.integer  "processed",    default: 0
    t.integer  "processed_by"
    t.datetime "processed_at"
  end

  create_table "place_rates", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "place_id",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "value"
  end

  add_index "place_rates", ["user_id", "place_id"], name: "place_rates_unique", unique: true, using: :btree

  create_table "place_reports", force: :cascade do |t|
    t.integer  "place_id",                 null: false
    t.integer  "user_id",                  null: false
    t.text     "reason"
    t.integer  "processed",    default: 0
    t.integer  "processed_by"
    t.datetime "processed_at"
  end

  create_table "place_services", id: false, force: :cascade do |t|
    t.integer  "place_id",   null: false
    t.integer  "service_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "place_services", ["place_id", "service_id"], name: "place_services_unique", unique: true, using: :btree

  create_table "place_tags", id: false, force: :cascade do |t|
    t.integer  "place_id",   null: false
    t.integer  "tag_id",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "place_tags", ["place_id", "tag_id"], name: "place_tags_unique", unique: true, using: :btree

  create_table "place_translations", force: :cascade do |t|
    t.integer  "place_id",    null: false
    t.string   "locale",      null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "name"
    t.text     "description"
    t.string   "address"
    t.string   "city"
  end

  add_index "place_translations", ["locale"], name: "index_place_translations_on_locale", using: :btree
  add_index "place_translations", ["place_id"], name: "index_place_translations_on_place_id", using: :btree

  create_table "places", force: :cascade do |t|
    t.string   "website"
    t.string   "postal_code"
    t.decimal  "latitude",    precision: 8, scale: 5
    t.decimal  "longitude",   precision: 8, scale: 5
    t.decimal  "rating",                              default: 0.0
    t.integer  "region_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "emails",                              default: [],  null: false, array: true
    t.string   "phones",                              default: [],  null: false, array: true
    t.integer  "poster_id"
  end

  add_index "places", ["region_id"], name: "index_places_on_region_id", using: :btree

  create_table "post_items", force: :cascade do |t|
    t.integer  "post_id"
    t.integer  "item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "post_items", ["item_id"], name: "index_post_items_on_item_id", using: :btree
  add_index "post_items", ["post_id"], name: "index_post_items_on_post_id", using: :btree

  create_table "post_locations", force: :cascade do |t|
    t.integer  "post_id"
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "post_locations", ["location_id"], name: "index_post_locations_on_location_id", using: :btree
  add_index "post_locations", ["post_id"], name: "index_post_locations_on_post_id", using: :btree

  create_table "post_translations", force: :cascade do |t|
    t.integer  "post_id",                 null: false
    t.string   "locale",      limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title",       limit: 255
    t.text     "description"
  end

  add_index "post_translations", ["locale"], name: "index_post_translations_on_locale", using: :btree
  add_index "post_translations", ["post_id"], name: "index_post_translations_on_post_id", using: :btree

  create_table "post_users", force: :cascade do |t|
    t.integer  "post_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "post_users", ["post_id"], name: "index_post_users_on_post_id", using: :btree
  add_index "post_users", ["user_id"], name: "index_post_users_on_user_id", using: :btree

  create_table "posts", force: :cascade do |t|
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

  add_index "posts", ["location_id"], name: "index_posts_on_location_id", using: :btree
  add_index "posts", ["user_id"], name: "index_posts_on_user_id", using: :btree

  create_table "provider_places", id: false, force: :cascade do |t|
    t.integer  "provider_id", null: false
    t.integer  "place_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "provider_places", ["provider_id", "place_id"], name: "provider_places_unique", unique: true, using: :btree

  create_table "provider_translations", force: :cascade do |t|
    t.integer  "provider_id", null: false
    t.string   "locale",      null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "name"
    t.text     "description"
  end

  add_index "provider_translations", ["locale"], name: "index_provider_translations_on_locale", using: :btree
  add_index "provider_translations", ["provider_id"], name: "index_provider_translations_on_provider_id", using: :btree

  create_table "provider_users", id: false, force: :cascade do |t|
    t.integer  "provider_id", null: false
    t.integer  "user_id",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "provider_users", ["provider_id", "user_id"], name: "provider_users_unique", unique: true, using: :btree

  create_table "providers", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "region_translations", force: :cascade do |t|
    t.integer  "region_id",  null: false
    t.string   "locale",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
    t.string   "center"
  end

  add_index "region_translations", ["locale"], name: "index_region_translations_on_locale", using: :btree
  add_index "region_translations", ["region_id"], name: "index_region_translations_on_region_id", using: :btree

  create_table "regions", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "service_translations", force: :cascade do |t|
    t.integer  "service_id",  null: false
    t.string   "locale",      null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "name"
    t.text     "description"
  end

  add_index "service_translations", ["locale"], name: "index_service_translations_on_locale", using: :btree
  add_index "service_translations", ["service_id"], name: "index_service_translations_on_service_id", using: :btree

  create_table "services", force: :cascade do |t|
    t.string   "icon"
    t.string   "color"
    t.datetime "created_at"
    t.datetime "updated_at"
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

  create_table "tag_translations", force: :cascade do |t|
    t.integer  "tag_id",     null: false
    t.string   "locale",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
  end

  add_index "tag_translations", ["locale"], name: "index_tag_translations_on_locale", using: :btree
  add_index "tag_translations", ["tag_id"], name: "index_tag_translations_on_tag_id", using: :btree

  create_table "tags", force: :cascade do |t|
    t.boolean  "permit",     default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "todos", force: :cascade do |t|
    t.string   "description"
    t.string   "condition"
    t.string   "alert"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "uploads", force: :cascade do |t|
    t.integer  "user_id",                  null: false
    t.integer  "place_id",                 null: false
    t.integer  "asset_id",                 null: false
    t.integer  "processed",    default: 0
    t.integer  "processed_by"
    t.datetime "processed_at"
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
    t.boolean  "is_service_provider",                default: false
    t.boolean  "has_agreed",                         default: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
