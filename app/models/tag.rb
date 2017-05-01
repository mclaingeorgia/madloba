class Tag < ActiveRecord::Base
  translates :name
  globalize_accessors :locales => [:en, :ka], :attributes => [ :name ]

  belongs_to :places
end
