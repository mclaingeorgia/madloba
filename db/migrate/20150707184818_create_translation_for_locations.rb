class CreateTranslationForLocations < ActiveRecord::Migration
  def up
    Location.create_translation_table!({ name: :string,
                                         address: :string,
                                         postal_code: :string,
                                         province: :string,
                                         city: :string,
                                         description: :text}, {migrate_data: true})
  end

  def down
    Location.drop_translation_table! migrate_data: true
  end
end
