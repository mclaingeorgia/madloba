class CreateAdLocations < ActiveRecord::Migration
  def change
    create_table :ad_locations do |t|
      t.references :ad, index: true
      t.references :location, index: true

      t.timestamps
    end
  end
end
