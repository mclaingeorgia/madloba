class RemoveUnusedTables < ActiveRecord::Migration
  def change
    remove_table :areas
    remove_table :categories
    remove_table :categories_posts
    remove_table :category_translations
    remove_table :delayed_jobs
    remove_table :district_translations
    remove_table :faqs
    remove_table :faq_translations
    remove_table :items
    remove_table :item_translations
    remove_table :location
    remove_table :location_translations
    remove_table :map_tiles
    remove_table :posts
    remove_table :post_items
    remove_table :post_locations
    remove_table :post_translations
    remove_table :post_users
    remove_table :settings
    remove_table :setting_translations
    remove_table :simple_captcha_data
    remove_table :todos
  end
end
