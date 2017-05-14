class ChangeTypeOfEmailPhoneForPlace < ActiveRecord::Migration
  def change
    add_column :places, :emails, :string, array: true, default: [], null: false
    remove_column :places, :phone
    add_column :places, :phones, :string, array: true, default: [], null: false
  end
end
