class AddBlockUnitVillageToLocationTranslations < ActiveRecord::Migration
  def up
    Location.add_translation_fields! block_unit: :string
    Location.add_translation_fields! village: :string
  end

  def down
    remove_column :location_translations, :block_unit
    remove_column :location_translations, :village
  end
end
