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
#  position     :integer          default(1)
#

class Service < ActiveRecord::Base
    include Nameable
    acts_as_list scope: [:ancestry]
    has_ancestry

  # globalize

    translates :name, :description
    globalize_accessors :locales => [:en, :ka], :attributes => [ :name, :description]

  # associations

    belongs_to :place

  # scopes

    def self.sorted
      with_translations(I18n.locale).order(position: :asc, name: :asc)
    end

  # validators

    validates :icon, presence: true, if: Proc.new { |x| x.ancestry.blank? }

    I18n.available_locales.each do |locale|
      validates :"name_#{locale}", presence: true
      # validates :"description_#{locale}", presence: true
    end

  # callbacks

    before_create :set_position

    # this record will not have a position so figure out the current last value and then
    # assign it to the new record
    def set_position
      position = if self.ancestry.nil?
        # this is a root service
        Service.roots.pluck(:position).sort.last
      else
        # this is a sub-service
        Service.where.(parent_id: self.parent_id).pluck(:position).sort.last
      end

      self.position = position.nil? ? 1 : (position+1)
    end

  # helpers
    def self.validation_order_list
      [Service.globalize_attribute_names, :for_children, :for_adults, :position, :icon].flatten
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
