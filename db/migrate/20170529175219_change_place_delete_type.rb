class ChangePlaceDeleteType < ActiveRecord::Migration
  def change
    remove_column :places, :deleted, :boolean, default: false
    add_column :places, :deleted, :integer, default: 0 # 1 deleted place, 2 deleted from provider
  end
end
