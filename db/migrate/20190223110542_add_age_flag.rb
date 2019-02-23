class AddAgeFlag < ActiveRecord::Migration
  def change
    add_column :places, :for_children, :boolean, default: true
    add_column :places, :for_adults, :boolean, default: true
  end
end
