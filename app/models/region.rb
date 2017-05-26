class Region < ActiveRecord::Base
  translates :name, :center
  globalize_accessors :locales => [:en, :ka], :attributes => [ :name, :center]

  has_one :place

  def self.sorted
    with_translations(I18n.locale).order(name: :asc)
  end
end
