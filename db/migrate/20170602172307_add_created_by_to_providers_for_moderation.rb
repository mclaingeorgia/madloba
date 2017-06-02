class AddCreatedByToProvidersForModeration < ActiveRecord::Migration
  def change
    add_column :providers, :created_by, :integer
  end
end
