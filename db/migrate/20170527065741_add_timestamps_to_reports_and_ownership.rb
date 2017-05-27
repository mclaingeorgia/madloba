class AddTimestampsToReportsAndOwnership < ActiveRecord::Migration
  def change
    add_timestamps :place_reports
    add_timestamps :place_ownerships
    add_timestamps :uploads
  end
end
