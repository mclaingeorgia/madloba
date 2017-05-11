class SetDefaultValueOnIsServiceProviderForUser < ActiveRecord::Migration
  def change
    change_column :users, :is_service_provider, :boolean, :default => false
  end
end
