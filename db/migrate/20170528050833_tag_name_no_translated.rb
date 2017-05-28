class TagNameNoTranslated < ActiveRecord::Migration
  def up
    drop_table :tag_translations
  end
  def down
    create_table :tag_translations do |t|
      t.integer :tag_id, null: false
      t.string :locale, null: false
      t.string :name
      t.timestamps
    end
  end
end
