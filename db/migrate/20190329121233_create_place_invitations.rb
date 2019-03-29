class CreatePlaceInvitations < ActiveRecord::Migration
  def change
    create_table :place_invitations do |t|
      t.references :place, index: true, foreign_key: true
      t.string :email
      t.boolean :has_accepted, default: false
      t.string :token
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end

    add_reference :place_invitations, :sent_by, index: true
    add_foreign_key :place_invitations, :users, column: :sent_by_id

    add_index :place_invitations, :email
    add_index :place_invitations, :has_accepted
    add_index :place_invitations, :token
  end
end
