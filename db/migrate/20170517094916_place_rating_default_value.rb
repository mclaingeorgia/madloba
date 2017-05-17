class PlaceRatingDefaultValue < ActiveRecord::Migration
  def change
    change_column :places, :rating, :decimal, :default => 0
  end
end
