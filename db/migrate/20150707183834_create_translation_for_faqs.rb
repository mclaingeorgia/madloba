class CreateTranslationForFaqs < ActiveRecord::Migration
  def up
    Faq.create_translation_table!({ question: :string, answer: :string }, {migrate_data: true})
  end

  def down
    Faq.drop_translation_table! migrate_data: true
  end
end
