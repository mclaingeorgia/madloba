class UpdatePlaceWebsiteToArray < ActiveRecord::Migration
  def change
    remove_column :places, :website
    add_column :places, :websites, :string, array: true, default: [], null: false
  end
end
