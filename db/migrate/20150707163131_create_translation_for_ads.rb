class CreateTranslationForAds < ActiveRecord::Migration
  def up
    Ad.create_translation_table!({ title: :string, description: :text}, {migrate_data: true})
  end

  def down
    Ad.drop_translation_table! migrate_data: true
  end
end
