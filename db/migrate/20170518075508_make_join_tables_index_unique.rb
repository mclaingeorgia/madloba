class MakeJoinTablesIndexUnique < ActiveRecord::Migration
  def change
    rename_table :rates, :place_rates

    remove_index(:favorite_places, column: [:place_id, :user_id])
    remove_index(:provider_users, column: [:provider_id, :user_id])
    remove_index(:provider_places, column: [:provider_id, :place_id])
    remove_index(:place_services, column: [:place_id, :service_id])
    remove_index(:place_tags, column: [:place_id, :tag_id])
    remove_index(:place_rates, column: [:user_id, :place_id])

    add_index :favorite_places, [:place_id, :user_id], unique: true, name: 'favorite_places_unique'
    add_index :provider_users, [:provider_id, :user_id], unique: true, name: 'provider_users_unique'
    add_index :provider_places, [:provider_id, :place_id], unique: true, name: 'provider_places_unique'
    add_index :place_services, [:place_id, :service_id], unique: true, name: 'place_services_unique'
    add_index :place_tags, [:place_id, :tag_id], unique: true, name: 'place_tags_unique'
    add_index :place_rates, [:user_id, :place_id], unique: true, name: 'place_rates_unique'


  end
end
