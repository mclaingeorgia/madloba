class CreateAdsCategories < ActiveRecord::Migration
  def change
    create_table :ads_categories do |t|
      t.references :ad, index: true
      t.references :category, index: true

      t.timestamps
    end
  end
end
