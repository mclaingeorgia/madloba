# == Schema Information
#
# Table name: provider_places
#
#  provider_id :integer          not null
#  place_id    :integer          not null
#  created_at  :datetime
#  updated_at  :datetime
#

class ProviderPlace < ActiveRecord::Base
  belongs_to :provider
  belongs_to :place
end
