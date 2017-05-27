class AddPublishedToPlace < ActiveRecord::Migration
  def change
    add_column :places, :published, :boolean, default: false
  end
end
