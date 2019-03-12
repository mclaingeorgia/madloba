# == Schema Information
#
# Table name: regions
#
#  id         :integer          not null, primary key
#  created_at :datetime
#  updated_at :datetime
#  latitude   :decimal(8, 5)    default(41.44273)
#  longitude  :decimal(8, 5)    default(45.79102)
#

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
