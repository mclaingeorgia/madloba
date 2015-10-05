class AddAnonEmail2AnonEmail3ToAds < ActiveRecord::Migration
  def change
    add_column :ads, :anon_email_2, :string
    add_column :ads, :anon_email_3, :string
  end
end
