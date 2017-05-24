class AddAssetsFields < ActiveRecord::Migration
  def change
    add_column :assets, :owner_id, :integer
    add_column :assets, :owner_type, :integer
    add_column :assets, :image, :string
  end
end
