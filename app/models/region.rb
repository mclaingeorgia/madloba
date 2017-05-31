class Region < ActiveRecord::Base

  # globalize

    translates :name, :center
    globalize_accessors :locales => [:en, :ka], :attributes => [ :name, :center]

  # associations

    has_one :place

  # scopes

    def self.sorted
      with_translations(I18n.locale).order(name: :asc)
    end

end
