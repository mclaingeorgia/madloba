# == Schema Information
#
# Table name: page_contents
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime
#  updated_at :datetime
#

class PageContent < ActiveRecord::Base
  include Nameable

  has_many :page_content_items, dependent: :destroy
  accepts_nested_attributes_for :page_content_items, :allow_destroy => true
  # globalize

    translates :title, :header, :content
    globalize_accessors :locales => [:en, :ka], :attributes => [:title, :header, :content]

  # scopes

    def self.sorted
      order(:name, :created_at)
    end

  # validators

    validates :name, presence: true, uniqueness: true
    I18n.available_locales.each do |locale|
      validates :"title_#{locale}", presence: true
      # validates :"content_#{locale}", presence: true
    end

  # helpers

    def self.validation_order_list # used to order flash messages
      [PageContent.globalize_attribute_names].flatten
    end
  # getters

    def self.by_name(name)
      find_by(name: name)
    end

end
