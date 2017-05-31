class RemoveColorFromServices < ActiveRecord::Migration
  def change
    remove_column :services, :color, :string
  end
end
