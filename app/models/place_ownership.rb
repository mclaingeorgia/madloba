class PlaceOwnership < ActiveRecord::Base

  belongs_to :user
  belongs_to :place
  belongs_to :provider

  # default_scope { where(:processed => 0) }
  scope :pending, -> { where(processed: 0) }

  validates :user_id, :place_id, :provider_id, presence: true

  def self.requested?(user_id, place_id)
    pending.find_by(user_id: user_id, place_id: place_id).present?
  end

  # def self.is_ownership_requested_for?(place_id)
  #   where(place_id: place_id).count() > 0
  # end

  # def self.is_ownership_requested_by?(user_id)
  #   where(user_id: user_id).count() > 0
  # end

  def self.request_ownership(current_user, place_id, provider_id, provider_params)
    response = nil
    class_name = self.model_name.param_key
    user_id = current_user.id

    if provider_id.present?
      provider = Provider.find(provider_id)
    else
      provider_params = provider_params.merge({ processed: 0, user_ids: [user_id] })
      provider = Provider.create!(provider_params.permit(*(Provider.globalize_attribute_names + [:processed, user_ids: []])))
      provider.user << current_user
    end

    place = Place.find(place_id)

    provider_id = provider.id

    if current_user.providers.include?(provider) && !current_user.providers.include?(Place.find(place_id))
      r = pending.find_by(user_id: user_id, place_id: place_id)
      if !r.present? && PlaceOwnership.create!(user_id: user_id, place_id: place_id, provider_id: provider_id)
        response = {type: :success, text: :succeed_to_process, action: class_name, forward: { refresh: { type: 'ownership' } }}
      end
    end

  rescue Exception => e
     Rails.logger.debug("-------------------------------------------#{class_name}-#{e}") # only dev
  ensure
    return response.present? ? response : {type: :error, text: :failed_to_process, action: class_name}
  end

  def process(current_user, state) # called when admin accepts or declines
    flag = true
    if state == 1
      if user.present? && provider.present? && place.present? && provider.users.include?(user) && !provider.places.include?(place)
        place.provider.places.delete(place)
        provider.places << place
      end
      flag = provider.places.include?(place)
    end
    return  flag && update_attributes(processed: state, processed_by: current_user.id)
  rescue Exception => e
     Rails.logger.debug("--------------------------------------------#{e}")
    false
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
