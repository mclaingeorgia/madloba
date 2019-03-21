class AddPlaceServiceFlags < ActiveRecord::Migration
  def change
    add_column :place_services, :published, :boolean, default: false, index: true
    add_column :place_services, :deleted, :integer, default: 0, index: true
  end
end
