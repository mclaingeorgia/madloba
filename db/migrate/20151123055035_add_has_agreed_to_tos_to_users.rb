class AddHasAgreedToTosToUsers < ActiveRecord::Migration
  def change
    add_column :users, :has_agreed_to_tos, :boolean, default: false
  end
end
