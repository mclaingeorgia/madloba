class Provider < ActiveRecord::Base
  include Nameable
  include HumanTranslatable

  # globalize

    translates :name, :description
    globalize_accessors :locales => [:en, :ka], :attributes => [:name, :description]

  # accessors

    attr_accessor :redirect_default

  # associations
    belongs_to :user, foreign_key: "created_by"
    has_many :provider_users
    has_many :users, through: :provider_users, source: :user

    has_many :provider_places
    has_many :places, -> { where( 'places.deleted': false) }, through: :provider_places, source: :place

  # scopes

    # default_scope { where.not(id: 1) }

    scope :only_deleted, -> { where(deleted: true) }
    scope :not_deleted, -> { where(deleted: false) }
    # scope :only_pending, -> { where(processed: 0) }
    # scope :only_processed, -> { where('providers.processed = 1 or providers.processed = 2') }
    scope :only_processed, -> { where('providers.processed is not null') } # those that where moderated once
    scope :only_active, -> { where('providers.deleted = false and (providers.processed is null or providers.processed = 1)') }
    scope :for_user, -> (user, admin_scope = false) {
      admin_scope ? all : joins(:users).where(users: { id: user.id})
    }
    scope :with_places, -> { includes(:places) }
    scope :excluding, -> (id) { where.not(id: id) }
    scope :sorted, -> { with_translations(I18n.locale).order(name: :asc) }
    scope :unknown, -> { where(id: 1) }
  # validators

    [I18n.locale].each do |locale|
      validates :"name_#{locale}", presence: true
      validates :"description_#{locale}", presence: true
    end

  # helpers

    def self.validation_order_list # used to order flash messages
      [Provider.globalize_attribute_names].flatten
    end

    def can_accept?
      [0].include?(self.processed)
    end
    def can_decline?
      [0].include?(self.processed)
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

  # getters

end
