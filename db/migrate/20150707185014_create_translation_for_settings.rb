class CreateTranslationForSettings < ActiveRecord::Migration
  def up
    Setting.create_translation_table!({ value: :string }, {migrate_data: true})
  end

  def down
    Setting.drop_translation_table! migrate_data: true
  end
end
