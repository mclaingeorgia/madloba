class AddResourceModel < ActiveRecord::Migration
  def change
    create_table "resource_content_translations", force: :cascade do |t|
      t.integer  "resource_content_id", null: false
      t.string   "locale",               null: false
      t.datetime "created_at",           null: false
      t.datetime "updated_at",           null: false
      t.text     "content"
    end

    add_index "resource_content_translations", ["locale"], name: "index_resource_content_translations_on_locale", using: :btree
    add_index "resource_content_translations", ["resource_content_id"], name: "index_resource_content_translations_on_resource_content_id", using: :btree

    create_table "resource_contents", force: :cascade do |t|
      t.integer  "resource_item_id"
      t.integer  "order"
      t.string   "visual_en"
      t.string   "visual_ka"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "resource_item_translations", force: :cascade do |t|
      t.integer  "resource_item_id", null: false
      t.string   "locale",               null: false
      t.datetime "created_at",           null: false
      t.datetime "updated_at",           null: false
      t.string   "title"
    end

    add_index "resource_item_translations", ["locale"], name: "index_resource_item_translations_on_locale", using: :btree
    add_index "resource_item_translations", ["resource_item_id"], name: "index_resource_item_translations_on_resource_item_id", using: :btree

    create_table "resource_items", force: :cascade do |t|
      t.integer  "resource_id"
      t.integer  "order"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "resource_translations", force: :cascade do |t|
      t.integer  "resource_id", null: false
      t.string   "locale",          null: false
      t.datetime "created_at",      null: false
      t.datetime "updated_at",      null: false
      t.string   "title"
      t.text     "content"
    end

    add_index "resource_translations", ["locale"], name: "index_resource_translations_on_locale", using: :btree
    add_index "resource_translations", ["resource_id"], name: "index_resource_translations_on_resource_id", using: :btree

    create_table "resources", force: :cascade do |t|
      t.string   "cover"
      t.integer  "order"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
