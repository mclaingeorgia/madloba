class RenameUserHasAgreedToTos < ActiveRecord::Migration
  def change
    rename_column :users, :has_agreed_to_tos, :has_agreed
  end
end
