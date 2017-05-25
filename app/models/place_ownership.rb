class PlaceOwnership < ActiveRecord::Base

  belongs_to :user
  belongs_to :place

  default_scope { where(:processed => 0) }

  validates :user_id, :place_id, presence: true

  def self.requested?(user_id, place_id)
    find_by(user_id: user_id, place_id: place_id).present?
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

    r = find_by(user_id: user_id, place_id: place_id)

    if r.present? || PlaceOwnership.create(user_id: user_id, place_id: place_id)
      response = {type: :success, text: :succeed_to_process, action: class_name, forward: { refresh: { type: 'ownership' } }}
    end

  rescue Exception => e
     Rails.logger.debug("-------------------------------------------#{class_name}-#{e}") # only dev
  ensure
    return response.present? ? response : {type: :error, text: :failed_to_process, action: class_name}
  end
end