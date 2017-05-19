class AddPrimaryKeyToPlaceRates < ActiveRecord::Migration
  def change
    add_column :place_rates, :id, :primary_key
  end
end
