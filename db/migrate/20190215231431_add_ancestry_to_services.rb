class AddAncestryToServices < ActiveRecord::Migration
  def change
    add_column :services, :ancestry, :string
    add_index :services, :ancestry
  end
end
