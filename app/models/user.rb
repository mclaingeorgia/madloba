class User < ActiveRecord::Base

  enum role: [:user, :admin, :super_admin]
  after_initialize :set_default_role, :if => :new_record?

  def set_default_role
    self.role ||= :user
  end

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  validates :username, presence: true
  validates :is_service_provider, inclusion: [true, false]
  validates_uniqueness_of :username

  # Fields to be translated
  translates :first_name, :last_name
  globalize_accessors :locales => [:en, :ka], :attributes => [:first_name, :last_name]

  has_many :locations, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :post_users
  has_many :favorite_posts, through: :post_users, source: :post

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
