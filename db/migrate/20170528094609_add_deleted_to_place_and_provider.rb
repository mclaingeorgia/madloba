class AddDeletedToPlaceAndProvider < ActiveRecord::Migration
  def change
    add_column :providers, :deleted, :boolean, default: false
    add_column :places, :deleted, :boolean, default: false
  end
end
