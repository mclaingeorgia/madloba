class FavoritePlace < ActiveRecord::Base
  belongs_to :user
  belongs_to :place

  validates :user_id, :place_id, presence: true

  def self.is_favorite_place?(user_id, place_id)
    find_by(user_id: user_id, place_id: place_id).present?
  end

  def self.favorite(user_id, place_id, value)
    response = nil
    class_name = self.model_name.param_key

    r = find_by(user_id: user_id, place_id: place_id)

    forward = { refresh: { type: 'favorite', to: true, place_id: place_id } }
    if value == true
      if r.present? || FavoritePlace.create(user_id: user_id, place_id: place_id)

        response = {type: :success, text: :succeed_to_process, action: class_name, forward: forward }
      end
    elsif value == false
      r.place.favoritors.destroy(user_id) if r.present?
      forward[:refresh][:to] = false
      response = {type: :success, text: :succeed_to_process_reject, action: class_name, forward: forward }
    end

  rescue Exception => e
     Rails.logger.debug("-------------------------------------------#{class_name}-#{e}") # only dev
  ensure
    return response.present? ? response : {type: :error, text: :failed_to_process, action: class_name}
  end
end
