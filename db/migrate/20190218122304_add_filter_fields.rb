class AddFilterFields < ActiveRecord::Migration
  def change
    add_column :services, :for_children, :boolean, default: true
    add_column :services, :for_adults, :boolean, default: true
  end
end
