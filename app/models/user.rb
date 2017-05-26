class User < ActiveRecord::Base
  # Fields to be translated
  translates :first_name, :last_name
  globalize_accessors :locales => [:en, :ka], :attributes => [:first_name, :last_name]

  include HumanTranslatable

  PROVIDERS_COUNT_MIN = 1
  # enum role: [:user, :admin, :super_admin]

  enum role: [:user, :provider, :admin]

  # has_many :providers#, -> (object){ where(role: [:provider, :admin]) }

  has_many :provider_users
  has_many :providers, through: :provider_users#, :inverse_of => :user, :autosave => true

  has_many :favorite_places
  has_many :favorites, through: :favorite_places, source: :place

  has_many :place_rates
  has_many :rates, through: :place_rates, source: :place

  has_many :uploads

  # has_many :places
  # accepts_nested_attributes_for :provider_users
  accepts_nested_attributes_for :providers, :reject_if => :not_service_provider?

  after_initialize :set_default_role, :if => :new_record?

  def set_default_role
    self.role ||= :user
  end

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable


 [I18n.locale].each do |locale|
   validates :"first_name_#{locale}", presence: true
   validates :"last_name_#{locale}", presence: true
 end

  # validates :email, presence: true
  # validates_uniqueness_of :email

  validates :is_service_provider, inclusion: [true, false]
  validates :has_agreed, inclusion: [true], on: :create

  # validates :password, presence: true, on: :create
  # validates :password_confirmation, presence: true, on: :create

  validate :check_providers_number, on: :create

  def guest?
    nil?
  end

  def user?
    role == "user" || role == "provider" || role == "admin"
  end

  def provider?
    role == "provider" || role == "admin"
  end

  def admin?
    role == "admin"
  end

  # def owns_post? (post)
  #   self.posts.include?(post)
  # end

  # def is_admin_or_super_admin
  #   self.admin? || self.super_admin?
  # end

  def name
    "#{self.first_name} #{self.last_name}"
  end

  # def name_and_email
  #   "#{self.first_name} #{self.last_name} - #{self.email}"
  # end

  # used to order flash messages
  def self.validation_order_list
    [User.globalize_attribute_names, :email, :password, :password_confirmation].flatten
  end

  def self.sorted
    with_translations(I18n.locale).order(first_name: :asc, last_name: :asc)
  end

  def role_name
    I18n.t("activerecord.attributes.user.roles.#{self.role}")
  end
  private
    def not_service_provider?
      !self.is_service_provider
    end

    def providers_count_valid?
       Rails.logger.debug("--------------------------------------------#{self.providers.inspect}")
      providers.length >= PROVIDERS_COUNT_MIN
    end

    def check_providers_number
       # Rails.logger.debug("--------------------------------------------#{self.is_service_provider}#{providers_count_valid?}")
      if self.is_service_provider && !providers_count_valid?
        errors.add(:providers, :not_filled, count: 1)
      end
    end
end
