class Region < ActiveRecord::Base
  translates :name, :center
  globalize_accessors :locales => [:en, :ka], :attributes => [ :name, :center]

  belongs_to :place

  def self.sorted
    with_translations(I18n.locale).order(name: :asc)
  end
end
