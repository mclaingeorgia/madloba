class CreateTranslationForDistricts < ActiveRecord::Migration
  def up
    District.create_translation_table!({ name: :string }, {migrate_data: true})
  end

  def down
    District.drop_translation_table! migrate_data: true
  end
end
