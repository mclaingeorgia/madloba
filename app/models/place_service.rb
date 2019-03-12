# == Schema Information
#
# Table name: place_services
#
#  place_id   :integer          not null
#  service_id :integer          not null
#  created_at :datetime
#  updated_at :datetime
#

class PlaceService < ActiveRecord::Base
  belongs_to :place
  belongs_to :service
end
