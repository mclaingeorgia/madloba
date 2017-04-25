class Place < ActiveRecord::Base
  translates :name, :description, :city, :address
  globalize_accessors :locales => [:en, :ka], :attributes => [ :name, :description, :city, :address]

  belongs_to :provider

  has_one :region

  has_many :user_places
  has_many :favoriting_users, through: :user_places, source: :user

  has_many :place_services
  has_many :services, through: :place_services, source: :service

  has_many :assets

  has_many :tags

end
