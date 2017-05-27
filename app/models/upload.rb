class Upload < ActiveRecord::Base
  belongs_to :place
  belongs_to :user
  belongs_to :asset

  def processed_human
    ['pending', 'accepted', 'declined'][self.processed]
  end
end

