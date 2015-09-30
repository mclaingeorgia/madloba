class RemoveIsParentalSupportFundingSourceFromAds < ActiveRecord::Migration
  def change
    remove_column :ads, :is_parental_support, :boolean
    remove_column :ads, :funding_source, :string
  end
end
