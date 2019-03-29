# == Schema Information
#
# Table name: place_users
#
#  id         :integer          not null, primary key
#  place_id   :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class PlaceUser < ActiveRecord::Base
  belongs_to :place
  belongs_to :user
end
