class CreatePlaceReport < ActiveRecord::Migration
  def change
    create_table :place_reports do |t|
      t.integer :place_id, null: false
      t.integer :user_id, null: false
      t.text :reason
      t.integer :processed, default: 0 # 1 accepted 2 declined
      t.integer :processed_by
      t.datetime :processed_at
    end
  end
end
