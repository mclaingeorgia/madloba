class AddPhoneNumbersToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :add_phone_number, :string
    add_column :locations, :add_phone_number_2, :string
  end
end
