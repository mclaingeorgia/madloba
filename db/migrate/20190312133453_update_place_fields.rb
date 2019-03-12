class UpdatePlaceFields < ActiveRecord::Migration
  def up
    remove_column :places, :websites
    remove_column :places, :phones
    remove_column :places, :emails

    add_column :place_translations, :director, :string
    add_column :places, :email, :string
    add_column :places, :website, :string
    add_column :places, :facebook, :string
    add_column :places, :phone, :string
    add_column :places, :phone2, :string
  end

  def down
    remove_column :place_translations, :director, :string
    remove_column :places, :email, :string
    remove_column :places, :website, :string
    remove_column :places, :facebook, :string
    remove_column :places, :phone, :string
    remove_column :places, :phone2, :string

    add_column :places, :emails, :string, array: true, default: [], null: false
    add_column :places, :websites, :string, array: true, default: [], null: false
    add_column :places, :phones, :string, array: true, default: [], null: false
  end
end
