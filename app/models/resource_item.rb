class ResourceItem < ActiveRecord::Base
  include Nameable

  belongs_to :resource

  has_many :resource_contents, dependent: :destroy
  accepts_nested_attributes_for :resource_contents, :allow_destroy => true

  # globalize

    translates :title
    globalize_accessors :locales => [:en, :ka], :attributes => [:title]

  # scopes
    default_scope { order(:order) }

    def self.sorted
      order(order: :asc)
    end

  # validators

    I18n.available_locales.each do |locale|
      validates :"title_#{locale}", presence: true
    end

  # getters

end
