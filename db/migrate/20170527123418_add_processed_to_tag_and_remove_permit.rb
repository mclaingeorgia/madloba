class AddProcessedToTagAndRemovePermit < ActiveRecord::Migration
  def change
    remove_column :tags, :permit
    # add_column :tags, :user_id, :integer
    add_column :tags, :processed, :integer
    add_column :tags, :processed_by, :integer
  end
end
