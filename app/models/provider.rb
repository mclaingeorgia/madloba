class Provider < ActiveRecord::Base
  translates :name, :description

  has_many :provider_users
  has_many :users, through: :provider_users

  has_many :places
end
