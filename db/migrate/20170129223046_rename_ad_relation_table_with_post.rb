class RenameAdRelationTableWithPost < ActiveRecord::Migration
  def change
    rename_table :ad_locations, :post_locations
    rename_column :post_locations, :ad_id, :post_id
    rename_table :ad_translations, :post_translations
    rename_column :post_translations, :ad_id, :post_id
    rename_table :ads_categories, :categories_posts
    rename_column :categories_posts, :ad_id, :post_id
  end
end
