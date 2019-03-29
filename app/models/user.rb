# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      not null
#  encrypted_password     :string(255)      not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  role                   :integer
#  first_name             :string(255)
#  last_name              :string(255)
#  is_service_provider    :boolean          default(FALSE)
#  has_agreed             :boolean          default(FALSE)
#  deleted                :boolean          default(FALSE)
#

class User < ActiveRecord::Base
  include Nameable
  include HumanTranslatable
  include RequiredLocale
  # constants

    PROVIDERS_COUNT_MIN = 1

  # globalize

    translates :first_name, :last_name
    globalize_accessors :locales => [:en, :ka], :attributes => [:first_name, :last_name]

    # globalize_validations([:first_name, :last_name])

  # accessors

    enum role: [:user, :provider, :admin]
    attr_accessor :promote, :redirect_default

  # associations

    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :trackable, :validatable, :confirmable

    has_many :provider_users
    has_many :providers, -> { where('providers.deleted = false and (providers.processed is null or providers.processed = 1)') }, through: :provider_users
    accepts_nested_attributes_for :providers, :reject_if => :not_service_provider?

    has_many :place_users
    has_many :places, -> { where('places.deleted = false and (places.processed is null or places.processed = 1)') }, through: :place_users
    accepts_nested_attributes_for :places, :reject_if => :not_service_provider?

    has_many :favorite_places
    has_many :favorites, through: :favorite_places, source: :place

    has_many :place_rates
    has_many :rates, through: :place_rates, source: :place

    has_many :uploads

  # callbacks

    after_initialize :set_default_role, :if => :new_record?

    def set_default_role
      self.role ||= :user
    end

    before_validation :remove_blanks

    def remove_blanks
      I18n.available_locales.each do |locale|
        Globalize.with_locale(locale) do
          self.first_name = nil if self.first_name.blank?
          self.last_name = nil if self.last_name.blank?
        end
      end
    end

    before_save :update_role_if_is_service_provider

    def update_role_if_is_service_provider
      self.role = :provider if self.is_service_provider && !self.at_least_provider?
    end

    before_save :promote_to_admin

    def promote_to_admin
       Rails.logger.debug("--------------------------------------------#{self.promote}")
      self.role = :admin if self.promote == 'true' && !self.admin?
    end
  #scopes
    default_scope { where.not(email: 'application@sheaghe.ge').where(deleted: false) }

    def self.sorted
      joins(sanitize_sql_array(['LEFT JOIN "user_translations" ON "users"."id" = "user_translations"."user_id" AND "user_translations"."locale" = ?', I18n.locale]))
        .order('user_translations.first_name ASC, user_translations.last_name ASC')
    end

    validates :first_name, :last_name, presence: true
    validates :is_service_provider, inclusion: [true, false]
    validates :has_agreed, inclusion: [true], on: :create

  # helpers

    def guest?
      nil?
    end

    def at_least_user?
      user? || provider? || admin?
    end

    def at_least_provider?
      provider? || admin?
    end

    def at_least_admin?
      admin?
    end

  # helpers

    def self.validation_order_list # used to order flash messages
      [User.globalize_attribute_names, :email, :password, :password_confirmation].flatten
    end

  # getters

    def name
      "#{self.first_name} #{self.last_name}"
    end

    def role_name
      I18n.t("activerecord.attributes.user.roles.#{self.role}")
    end

    def self.admin_emails
      emails = []
      users = User.where(role: 2)
      emails = users.map{|m| m.email}.join(';') if users.present?
      return emails
    end
  # filters

    def self.autocomplete(q, user, related_id)
      provider = Provider.find_by(id: related_id)
      exclude_ids = []
      exclude_ids = provider.users.pluck(:id) if provider.present?
      if user.admin?
        User.where('lower(email) like ?', "%#{q.downcase}%").where.not(id: exclude_ids).pluck(:id, :email).map{|m| { id: m[0], text: m[1]} }
      else
        []
      end
    end

  private
    # validators

      def not_service_provider?
        !self.is_service_provider
      end

end
