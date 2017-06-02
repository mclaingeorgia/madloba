class AddProviderIdToPlaceOwnerships < ActiveRecord::Migration
  def change
    add_column :place_ownerships, :provider_id, :integer
  end
end
