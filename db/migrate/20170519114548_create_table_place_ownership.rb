class CreateTablePlaceOwnership < ActiveRecord::Migration
  def change
    create_table :place_ownerships do |t|
      t.integer :place_id, null: false
      t.integer :user_id, null: false
      t.integer :processed, default: 0 # 1 accepted 2 declined
      t.integer :processed_by
      t.datetime :processed_at
    end
  end
end
