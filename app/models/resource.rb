class Resource < ActiveRecord::Base
  include Nameable

  mount_uploader :cover, ResourceCoverUploader

  has_many :resource_items, dependent: :destroy
  accepts_nested_attributes_for :resource_items, :allow_destroy => true

  # globalize

    translates :title, :content, :fallbacks_for_empty_translations => true
    globalize_accessors :locales => [:en, :ka], :attributes => [:title, :content]

  # scopes
    default_scope { order(:order) }

    def self.sorted
      order(:created_at)
    end

  # validators
    validates :title_ka, presence: true
    # I18n.available_locales.each do |locale|
    #   validates :"title_#{locale}", presence: true
    # end

  # helpers

    def self.validation_order_list # used to order flash messages
      [Resource.globalize_attribute_names].flatten
    end

  # getters

end
