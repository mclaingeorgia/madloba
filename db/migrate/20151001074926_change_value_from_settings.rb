class ChangeValueFromSettings < ActiveRecord::Migration
  def up
    change_column :settings, :value, :text, :limit => nil
  end
  def down
    change_column :settings, :value, :string
  end
end