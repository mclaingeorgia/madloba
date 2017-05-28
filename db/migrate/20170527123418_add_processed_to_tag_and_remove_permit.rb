class AddProcessedToTagAndRemovePermit < ActiveRecord::Migration
  def change
    remove_column :tags, :permit, :boolean
    # add_column :tags, :user_id, :integer
    add_column :tags, :processed, :integer, default: 0
    add_column :tags, :processed_by, :integer
  end
end
