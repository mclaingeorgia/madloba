class Region < ActiveRecord::Base
  translates :name, :center
  globalize_accessors :locales => [:en, :ka], :attributes => [ :name, :center]

  belongs_to :place
end
