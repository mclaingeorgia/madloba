class ChangeValueFromSettingTranlations < ActiveRecord::Migration
  def up
    change_column :setting_translations, :value, :text, :limit => nil
  end
  def down
    change_column :setting_translations, :value, :string
  end
end
