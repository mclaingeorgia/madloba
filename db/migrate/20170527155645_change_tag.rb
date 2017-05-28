class ChangeTag < ActiveRecord::Migration
  def change
     add_column :tags, :user_id, :integer
     add_column :tags, :place_id, :integer
     add_column :tags, :name, :string
  end
end
