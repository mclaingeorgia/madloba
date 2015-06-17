class AddTextFieldsToAds < ActiveRecord::Migration
  def change
    add_column :ads, :funding_source, :string
    add_column :ads, :benef_age_group, :string
    add_column :ads, :is_parental_support, :boolean
  end
end
