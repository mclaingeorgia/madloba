# == Schema Information
#
# Table name: municipalities
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Municipality < ActiveRecord::Base

  # globalize

    translates :name
    globalize_accessors :locales => [:en, :ka], :attributes => [ :namer]

  # associations

    has_one :place

  # scopes

    def self.sorted
      with_translations(I18n.locale).order(name: :asc)
    end
end
