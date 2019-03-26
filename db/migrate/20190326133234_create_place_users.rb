class CreatePlaceUsers < ActiveRecord::Migration
  def change
    create_table :place_users do |t|
      t.references :place, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
