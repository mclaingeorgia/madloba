class AddMapEnglishGeorgianNamesToMapTiles < ActiveRecord::Migration
  def change
    add_column :map_tiles, :map_georgian_name, :string
    add_column :map_tiles, :map_english_name, :string
    remove_column :map_tiles, :map_name, :string
  end
end
