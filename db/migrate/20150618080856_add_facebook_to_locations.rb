class AddFacebookToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :facebook, :string
  end
end
