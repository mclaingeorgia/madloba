class CreateAdUsers < ActiveRecord::Migration
  def change
    create_table :ad_users do |t|
      t.references :ad, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
