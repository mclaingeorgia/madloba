class AddIsPublishedToAds < ActiveRecord::Migration
  def change
    add_column :ads, :is_published, :boolean
  end
end
