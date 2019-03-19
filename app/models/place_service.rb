# == Schema Information
#
# Table name: place_services
#
#  place_id                       :integer          not null
#  service_id                     :integer          not null
#  created_at                     :datetime
#  updated_at                     :datetime
#  is_restricited_geographic_area :boolean
#  geographic_area_municipalities :integer          default([]), not null, is an Array
#  service_type                   :integer          default([]), not null, is an Array
#  act_regulating_service         :string
#  act_link                       :string
#  description                    :text
#  has_age_restriction            :boolean
#  age_groups                     :integer          default([]), not null, is an Array
#  can_be_used_by                 :integer
#  diagnoses                      :string           default([]), not null, is an Array
#  service_activities             :string           default([]), not null, is an Array
#  service_specialists            :string           default([]), not null, is an Array
#  need_finance                   :boolean
#  get_involved_link              :string
#

class PlaceService < ActiveRecord::Base
  include Nameable
  extend ArrayEnum

  # associations
    belongs_to :place
    belongs_to :service

  # enums
    SERVICE_TYPES = {"municipal": 1, "state": 2, "private_org": 3}
    AGE_GROUPS = {"0-6": 1, "7-18": 2, "18-65": 3, "65+": 4}
    array_enum service_types: SERVICE_TYPES
    array_enum age_groups: AGE_GROUPS
    enum can_be_used_by: {"anyone": 1, "diagnosis_with_status": 2, "diagnosis_without_status": 3}

  # scopes

    def self.service_types_for_list
      I18n.t('activerecord.attributes.place_service.service_types').map{|k, v| [k,v]}
    end

    def self.age_groups_for_list
      AGE_GROUPS.map{|k,v| [k, k]}
    end

    def self.can_be_used_by_for_list
      I18n.t('activerecord.attributes.place_service.can_be_used_bies').map{|k, v| [k, v]}
    end

  # methods

    def service_icon
      self.service.root? ? self.service.icon : self.service.parent.icon
    end

    def root_service_name
      self.service.root? ? self.service.name : self.service.parent.name
    end

end
