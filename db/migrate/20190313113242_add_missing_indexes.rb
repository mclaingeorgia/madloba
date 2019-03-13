class AddMissingIndexes < ActiveRecord::Migration
  def change
    add_index :assets, :owner_id
    add_index :assets, :owner_type

    add_index :notification_triggers, :notification_type
    add_index :notification_triggers, :processed

    add_index :page_content_items, :order

    add_index :place_ownerships, :place_id
    add_index :place_ownerships, :user_id

    remove_index :place_rates, name: "place_rates_unique"
    add_index :place_rates, [:place_id, :user_id]

    add_index :place_reports, [:place_id, :user_id]
    add_index :place_reports, :processed

    add_index :place_translations, :name

    add_index :places, :deleted
    add_index :places, :published

    add_index :region_translations, :name

    add_index :resource_contents, :order
    add_index :resource_contents, :resource_item_id

    add_index :resource_items, :order

    add_index :resources, :order

    add_index :service_translations, :name

    add_index :tags, :processed
    add_index :tags, :place_id
    add_index :tags, :user_id

    add_index :uploads, :user_id
    add_index :uploads, :place_id
    add_index :uploads, :asset_id

    add_index :user_translations, [:first_name, :last_name]

  end
end
