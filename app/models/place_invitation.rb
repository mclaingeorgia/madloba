# == Schema Information
#
# Table name: place_invitations
#
#  id           :integer          not null, primary key
#  place_id     :integer
#  email        :string
#  has_accepted :boolean          default(FALSE)
#  token        :string
#  user_id      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  sent_by_id   :integer
#

class PlaceInvitation < ActiveRecord::Base

  # associations
    belongs_to :place
    belongs_to :user
    belongs_to :sent_by, class_name: 'User'

  # validation
    validates :email, :sent_by, presence: true

  # contstant
    DAYS_TO_EXPIRE = 10

  # scope
    scope :by_token, -> (token) { where(token: token) }
    scope :by_email, -> (email) { where(email: email) }
    scope :for_place, -> (place_id) { where(place_id: place_id) }
    scope :for_user, -> (user_id) { where(user_id: user_id) }
    scope :pending, -> { where(has_accepted: false).where('created_at >= ?', (Time.now - DAYS_TO_EXPIRE.days))}
    scope :expired, -> { where(has_accepted: false).where('created_at < ?', (Time.now - DAYS_TO_EXPIRE.days))}
    scope :sorted, -> { order(created_at: :desc) }

  # callbacks
    before_create :generate_token
    after_save :process_acceptance

private

  # methods

  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless self.class.exists?(token: random_token)
    end
  end

  # when invitaiton is accepted:
  # - make sure the user has provider role
  # - add to place
  def process_acceptance
    if has_accepted_changed? && has_accepted == true
      if !self.user.at_least_provider?
        self.user.role = :provider
        self.user.save
      end
      self.place.users << self.user
    end
  end
end
