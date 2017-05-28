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

