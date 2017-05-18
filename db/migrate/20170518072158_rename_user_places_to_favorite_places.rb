class RenameUserPlacesToFavoritePlaces < ActiveRecord::Migration
  def change
    rename_table :user_places, :favorite_places
  end
end
