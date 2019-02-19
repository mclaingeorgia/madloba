class AddServiceSort < ActiveRecord::Migration
  def change
    add_column :services, :sort, :integer, default: 1
    add_index :services, :sort
  end
end
