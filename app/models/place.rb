class Place < ActiveRecord::Base
  translates :name, :description, :address, :village, :city
  globalize_accessors :locales => [:en, :ka], :attributes => [ :name, :description, :address, :village, :city]

  belongs_to :provider

  has_many :user_places
  has_many :favoriting_users, through: :user_places, source: :user

  has_many :services

  has_many :assets

  has_many :tags
end
