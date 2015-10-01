class AddLegalFormToAds < ActiveRecord::Migration
  def change
    add_column :ads, :legal_form, :string
  end
end
