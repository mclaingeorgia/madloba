class PlaceRate < ActiveRecord::Base
  belongs_to :user
  belongs_to :place

  after_commit :calculate_place_rating

  validates :user_id, :place_id, :value, presence: true

  def calculate_place_rating
    r = PlaceRate.where(place_id: self.place_id)
    p = Place.find_by(id: self.place_id)
    p.update({rating: (r.sum(:value)+0.0)/r.count()})
  end

  def self.rate(user_id, place_id, value)
    r = find_by(user_id: user_id, place_id: place_id)

    if value > 0 && value <= 5
      if r.present? ? r.update({value: value}) : PlaceRate.create(user_id: user_id, place_id: place_id, value: value)
        return {type: :success, text: :place_rate_succeed, forward: { refresh_rating: Place.find_by(id: place_id).get_rating }}
      else
        return {type: :error, text: :place_rate_failed}
      end
    elsif value == 0
      r.destroy if r.present?
      return {type: :success, text: :favorite_place_false_succeed, forward: { refresh_rating: Place.find_by(id: place_id).get_rating }}
    end
  end


  def self.get_rate(user_id, place_id)
    r = find_by(user_id: user_id, place_id: place_id)
    r.present? ? r.value : 0
  end
end
