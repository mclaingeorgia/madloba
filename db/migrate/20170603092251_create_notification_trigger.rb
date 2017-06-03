class CreateNotificationTrigger < ActiveRecord::Migration
  def change
    create_table :notification_triggers do |t|
      t.integer :notification_type
      t.integer :related_id
      t.boolean :processed, default: false

      t.timestamps
    end
  end
end
