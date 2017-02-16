class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  has_many :locations, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :post_users
  has_many :favorite_posts, through: :post_users, source: :post

  TRANSLATED_FIELDS = [:first_name, :last_name]

  before_create :populate_required_fields_missing_translations

  enum role: [:user, :admin, :super_admin]
  after_initialize :set_default_role, :if => :new_record?

  validates :username, presence: true
  validates :is_service_provider, inclusion: [true, false]
  validates_uniqueness_of :username

  # Fields to be translated
  translates *TRANSLATED_FIELDS
  globalize_accessors :locales => I18n.available_locales, :attributes => TRANSLATED_FIELDS

  def populate_required_fields_missing_translations
    default_locale = I18n.default_locale
    other_locales = I18n.without_default_locales

    TRANSLATED_FIELDS.each { |item|
      default_value = self.send("#{item}_#{default_locale}")
      if default_value.present?
        other_locales.each { |locale|
          self.send("#{item}_#{locale}=", default_value) unless self.send("#{item}_#{locale}").present?
        }
      end
    }
  end

  def set_default_role
    self.role ||= :user
  end

  def owns_post? (post)
    self.posts.include?(post)
  end

  def is_admin_or_super_admin
    self.admin? || self.super_admin?
  end

  def name_and_email
    "#{self.first_name} #{self.last_name} - #{self.email}"
  end

  def has_accepted_terms_and_conditions
    errors.add(:base, I18n.t('admin.profile.please_agree')) if (self.has_agreed_to_tos.nil? || !self.has_agreed_to_tos)
  end
end
