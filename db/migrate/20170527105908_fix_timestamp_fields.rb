class FixTimestampFields < ActiveRecord::Migration
  def change
    remove_column :place_ownerships, :processed_at
    remove_column :place_reports, :processed_at
    remove_column :uploads, :processed_at
  end
end
