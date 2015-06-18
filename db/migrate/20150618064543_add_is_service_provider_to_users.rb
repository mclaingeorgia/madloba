class AddIsServiceProviderToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_service_provider, :boolean
  end
end
