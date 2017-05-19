class PlaceOwnership < ActiveRecord::Base

  belongs_to :user
  belongs_to :place

  default_scope { where(:processed => 0) }

  validates :user_id, :place_id, presence: true

  def self.is_ownership_requested?(user_id, place_id)
    find_by(user_id: user_id, place_id: place_id).present?
  end

  def self.is_ownership_requested_for?(place_id)
    where(place_id: place_id).count() > 0
  end

  def self.is_ownership_requested_by?(user_id)
    where(user_id: user_id).count() > 0
  end

  def self.request_ownership(user_id, place_id)
    r = find_or_create_by(user_id: user_id, place_id: place_id)
    if r.new_record?
      return {type: :error, text: :already_requested}
    else
      return {type: :success, text: :request_ownership_succeed}
    end
  end


end
