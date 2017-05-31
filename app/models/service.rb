class Service < ActiveRecord::Base
  include Nameable

  # globalize

    translates :name, :description
    globalize_accessors :locales => [:en, :ka], :attributes => [ :name, :description]

  # associations

    belongs_to :place

  # scopes

    def self.sorted
      with_translations(I18n.locale).order(name: :asc)
    end

  # validators

    validates :icon, presence: true

    I18n.available_locales.each do |locale|
      validates :"name_#{locale}", presence: true
      validates :"description_#{locale}", presence: true
    end
end
