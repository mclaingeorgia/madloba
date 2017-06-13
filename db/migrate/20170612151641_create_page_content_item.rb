class CreatePageContentItem < ActiveRecord::Migration
  def change
    add_column :page_content_translations, :header, :string
    create_table :page_content_items do |t|
      t.integer  :page_content_id
      t.integer :order
      t.timestamps
    end

    reversible do |dir|
      dir.up do
        PageContentItem.create_translation_table! :title => :string, :content => :text
      end

      dir.down do
        PageContentItem.drop_translation_table!
      end
    end

  end
end
