# == Schema Information
#
# Table name: uploads
#
#  id           :integer          not null, primary key
#  user_id      :integer          not null
#  place_id     :integer          not null
#  asset_id     :integer          not null
#  processed    :integer          default(0)
#  processed_by :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class Upload < ActiveRecord::Base
  belongs_to :place
  belongs_to :user
  belongs_to :asset

  def self.sorted
    order(created_at: :desc)
  end

  def can_accept?
    [0,2].include?(self.processed)
  end
  def can_decline?
    [0,1].include?(self.processed)
  end
  def is_processed?
    [1,2].include?(self.processed)
  end
  def is_pending?
    [0].include?(self.processed)
  end
  def processed_human
    ['pending', 'accepted', 'declined'][self.processed]
  end
end

