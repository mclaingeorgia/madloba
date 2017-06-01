class AddProcessedToProvider < ActiveRecord::Migration
  def change
    add_column :providers, :processed, :integer, default: 0 # 1 accepted, 2 declined
    add_column :providers, :processed_by, :integer
  end
end
