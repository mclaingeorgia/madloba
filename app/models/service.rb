class Service < ActiveRecord::Base
  translates :name, :description
  globalize_accessors :locales => [:en, :ka], :attributes => [ :name, :description]

  belongs_to :place
  # has_many :place_services
  # has_many :services, through: :place_services, source: :place
  # has_and_belongs_to_many :places
end
