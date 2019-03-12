class CreateMunicipalities < ActiveRecord::Migration
  def change
    create_table :municipalities do |t|

      t.timestamps null: false
    end

    add_reference :places, :municipality, index: true

    reversible do |dir|
      dir.up do
        Municipality.create_translation_table! :name => :string
        add_index :municipality_translations, :name
      end

      dir.down do
        Municipality.drop_translation_table!
      end
    end

  end
end
