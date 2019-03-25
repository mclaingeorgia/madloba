class RenameServiceSort < ActiveRecord::Migration
  def up
    remove_index :services, :sort
    rename_column :services, :sort, :position
    add_index :services, :position
  end

  def down
    remove_index :services, :position
    rename_column :services, :position, :sort
    add_index :services, :sort
  end
end
