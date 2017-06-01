class Provider < ActiveRecord::Base
  include Nameable
  include HumanTranslatable

  # globalize

    translates :name, :description
    globalize_accessors :locales => [:en, :ka], :attributes => [:name, :description]

  # accessors

    attr_accessor :redirect_default

  # associations

    has_many :provider_users
    has_many :users, through: :provider_users, source: :user

    has_many :provider_places
    has_many :places, through: :provider_places, source: :place

  # scopes

    # default_scope { where.not(id: 1) }

    scope :deleted, -> { where(:deleted => true) }
    scope :active, -> { where(:deleted => false) }
    scope :accessible, -> { where(:deleted => false) }

    def self.sorted
      with_translations(I18n.locale).order(name: :asc)
    end

  # validators

    [I18n.locale].each do |locale|
      validates :"name_#{locale}", presence: true
      validates :"description_#{locale}", presence: true
    end

  # helpers

    def self.validation_order_list # used to order flash messages
      [Provider.globalize_attribute_names].flatten
    end

  # getters

    def self.by_user(user_id)
      joins(:users).where(:users => { :id => user_id}).includes(:places)
    end

    def self.unknown
      find_by(id: 1)
    end

end
