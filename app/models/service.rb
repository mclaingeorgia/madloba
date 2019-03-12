# == Schema Information
#
# Table name: services
#
#  id           :integer          not null, primary key
#  icon         :string
#  created_at   :datetime
#  updated_at   :datetime
#  ancestry     :string
#  for_children :boolean          default(TRUE)
#  for_adults   :boolean          default(TRUE)
#  sort         :integer          default(1)
#

class Service < ActiveRecord::Base
  include Nameable

    has_ancestry

  # globalize

    translates :name, :description
    globalize_accessors :locales => [:en, :ka], :attributes => [ :name, :description]

  # associations

    belongs_to :place

  # scopes

    def self.sorted
      with_translations(I18n.locale).order(sort: :asc, name: :asc)
    end

  # validators

    validates :icon, presence: true, if: Proc.new { |x| x.ancestry.blank? }

    I18n.available_locales.each do |locale|
      validates :"name_#{locale}", presence: true
      # validates :"description_#{locale}", presence: true
    end


  # methods

    # if record has icon return it
    # else if record is child, get parents icon
    def parent_icon
      i = nil

      if self.ancestry.nil?
        i = self.icon
      elsif self.ancestry.present?
        i = self.parent.icon
      end

      return i
    end

end
