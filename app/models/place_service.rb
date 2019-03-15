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
  extend ArrayEnum

  # associations
    belongs_to :place
    belongs_to :service

  # enums
    array_enum service_types: {"municipal": 1, "state": 2, "private_org": 3}
    array_enum age_groups: {"0-6": 1, "7-18": 2, "18-65": 3, "65+": 4}
    enum can_be_used_by: {"anyone": 1, "diagnosis-with-status": 2, "diagnosis-without-status": 3}


end
