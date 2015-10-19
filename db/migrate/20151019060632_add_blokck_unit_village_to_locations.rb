class AddBlokckUnitVillageToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :block_unit, :string
    add_column :locations, :village, :string
  end
end
