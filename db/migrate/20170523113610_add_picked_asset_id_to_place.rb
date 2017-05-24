class AddPickedAssetIdToPlace < ActiveRecord::Migration
  def change
    add_column :places, :poster_id, :integer
  end
end
