class AddLatitudeAndLongitudeToRegionCenter < ActiveRecord::Migration
  def change
    add_column :regions, :latitude, :decimal, precision: 8, scale: 5, default: 41.44273
    add_column :regions, :longitude, :decimal, precision: 8, scale: 5, default: 45.79102
  end
end
