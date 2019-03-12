# == Schema Information
#
# Table name: provider_users
#
#  provider_id :integer          not null
#  user_id     :integer          not null
#  created_at  :datetime
#  updated_at  :datetime
#

class ProviderUser < ActiveRecord::Base
  belongs_to :provider
  belongs_to :user
end
