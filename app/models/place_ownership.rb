class PlaceOwnership < ActiveRecord::Base

  belongs_to :user
  belongs_to :place

  # default_scope { where(:processed => 0) }
  scope :pending, -> { where(processed: 0) }

  validates :user_id, :place_id, presence: true

  def self.requested?(user_id, place_id)
    pending.find_by(user_id: user_id, place_id: place_id).present?
  end

  # def self.is_ownership_requested_for?(place_id)
  #   where(place_id: place_id).count() > 0
  # end

  # def self.is_ownership_requested_by?(user_id)
  #   where(user_id: user_id).count() > 0
  # end

  def self.request_ownership(user_id, place_id)
    response = nil
    class_name = self.model_name.param_key

    r = pending.find_by(user_id: user_id, place_id: place_id)
    if r.present? || PlaceOwnership.create(user_id: user_id, place_id: place_id)
      response = {type: :success, text: :succeed_to_process, action: class_name, forward: { refresh: { type: 'ownership' } }}
    end

  rescue Exception => e
     Rails.logger.debug("-------------------------------------------#{class_name}-#{e}") # only dev
  ensure
    return response.present? ? response : {type: :error, text: :failed_to_process, action: class_name}
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
