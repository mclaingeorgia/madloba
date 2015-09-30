class CreateTranslationForItems < ActiveRecord::Migration
  def up
    Item.create_translation_table!({ name: :string, description: :string }, {migrate_data: true})
  end

  def down
    Item.drop_translation_table! migrate_data: true
  end
end
