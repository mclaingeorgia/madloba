class User < ActiveRecord::Base
  include Nameable
  include HumanTranslatable

  # constants

    PROVIDERS_COUNT_MIN = 1

  # globalize

    translates :first_name, :last_name
    globalize_accessors :locales => [:en, :ka], :attributes => [:first_name, :last_name]

  # accessors

    enum role: [:user, :provider, :admin]

  # associations

    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :trackable, :validatable, :confirmable

    has_many :provider_users
    has_many :providers, -> { where('providers.deleted = false and (providers.processed is null or providers.processed = 1)') }, through: :provider_users
    accepts_nested_attributes_for :providers, :reject_if => :not_service_provider?

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


  #scopes
    default_scope { where.not(email: 'application@sheaghe.ge').where(deleted: false) }

    def self.sorted
      joins(sanitize_sql_array(['LEFT JOIN "user_translations" ON "users"."id" = "user_translations"."user_id" AND "user_translations"."locale" = ?', I18n.locale]))
        .order('user_translations.first_name ASC, user_translations.last_name ASC')
    end

  # validators
    # [I18n.locale].each do |locale|
    #  Rails.logger.debug("--------------------------------------------first_name_#{locale}")
    #   validates :"first_name_#{locale}", presence: true#, on: :create
    #   validates :"last_name_#{locale}", presence: true#, on: :create
    # end
    # validates :first_name_ka, presence: true, if: Proc.new {|p|
    #    Rails.logger.debug("--------------------------------------------#{I18n.locale}")
    #  I18n.locale == :ka }
    # validates :first_name_en, presence: true, if: Proc.new {|p| I18n.locale == :en }

    before_validation :add_instance_validations
    def add_instance_validations
       Rails.logger.debug("-------------------------------------------instance validatin")
      singleton_class.class_eval { validates :first_name_ka, presence: true }
    end
    # validates :first_name_ka, :presence => true, :if => :check_country

    # def check_country
    #    Rails.logger.debug("--------------------------------------------check first_name ka")
    #   I18n.locale == :ka
    #   # ["US", "Canada"].include?(self.country)
    # end


    validates :is_service_provider, inclusion: [true, false]
    validates :has_agreed, inclusion: [true], on: :create

    validate :check_providers_number, on: :create
    # validate :check_globalize_attributes

    # def check_globalize_attributes
    #   Globalize.with_locale(I18n.locale) do
    #    Rails.logger.debug("-------------------------------------------here #{self.first_name} #{self.last_name}")
    #     self.first_name. && self.last_name.present?
    #   end
    # end
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

      def check_providers_number
        if self.is_service_provider && !providers_count_valid?
          errors.add(:providers, :not_filled, count: 1)
        end
      end

      def not_service_provider?
        !self.is_service_provider
      end

      def providers_count_valid?
        providers.length >= PROVIDERS_COUNT_MIN
      end

end
