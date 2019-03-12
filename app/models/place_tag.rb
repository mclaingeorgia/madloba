# == Schema Information
#
# Table name: place_tags
#
#  place_id   :integer          not null
#  tag_id     :integer          not null
#  created_at :datetime
#  updated_at :datetime
#

class PlaceTag < ActiveRecord::Base
  belongs_to :place
  belongs_to :tag

  scope :pending, -> { where(processed: 0) }

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
