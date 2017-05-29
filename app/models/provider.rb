class Provider < ActiveRecord::Base
  translates :name, :description
  globalize_accessors :locales => [:en, :ka], :attributes => [:name, :description]

  attr_accessor :redirect_default
  # before_validation(on: :create) do
  #   Rails.logger.debug("-----------------------asdfdsf")
  #   true
  # end
  include HumanTranslatable
  # def self.human_attribute_name(attr, options = {})
  #    Rails.logger.debug("-----------------------provider1 #{attr}")
  #   if self.globalize_attribute_names.include?(attr)
  #     disassembled = attr.to_s.scan(/(.*)_(..)$/)[0]
  #    Rails.logger.debug("-----------------------provider2")
  #     "%s (%s)" % [I18n.t("#{i18n_scope}.attributes.#{self.name.underscore.downcase}.#{disassembled[0]}"), I18n.t("app.languages.#{disassembled[1]}")]
  #   else
  #     super
  #   end
  # end

  has_many :provider_users
  has_many :users, through: :provider_users

  has_many :provider_places
  has_many :places, through: :provider_places, source: :place

  # has_many :favoriting_users

  scope :deleted, -> { where(:deleted => true) }
  scope :active, -> { where(:deleted => false) }
  scope :accessible, -> { where(:deleted => false) }

  [I18n.locale].each do |locale|
    validates :"name_#{locale}", presence: true
    validates :"description_#{locale}", presence: true
  end

  def self.by_user(user_id)
    joins(:users).where(:users => { :id => user_id}).includes(:places)
  end

  def self.sorted
    with_translations(I18n.locale).order(name: :asc)
  end

  # used to order flash messages
  def self.validation_order_list
    [Provider.globalize_attribute_names].flatten
  end
end
