class AddPickedAssetIdToPlace < ActiveRecord::Migration
  def change
    add_column :places, :picked_asset_id, :integer
  end
end
