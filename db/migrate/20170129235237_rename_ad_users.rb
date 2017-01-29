class RenameAdUsers < ActiveRecord::Migration
  def change
    rename_table :ad_users, :post_users
    rename_column :post_users, :ad_id, :post_id
  end
end
