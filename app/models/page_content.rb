class PageContent < ActiveRecord::Base
  translates :title, :content
  globalize_accessors :locales => [:en, :ka], :attributes => [:title, :content]
  accepts_nested_attributes_for :translations

  #############################
  # Validations
  validates_presence_of :name
  validates_uniqueness_of :name

  # validate the translation fields
  # title need to be validated for presence

  #############################
  # Callbacks
  # before_save :set_to_nil

  # # if title or content are '', reset value to nil so fallback works
  # def set_to_nil
  #   self.title_translations.keys.each do |key|
  #     self.title_translations[key] = nil if !self.title_translations[key].nil? && self.title_translations[key].empty?
  #   end

  #   self.content_translations.keys.each do |key|
  #     self.content_translations[key] = nil if !self.content_translations[key].nil? && self.content_translations[key].empty?
  #   end
  # end

  #############################
  def self.sorted
    order(:name, :created_at)
  end

  def self.by_name(name)
    find_by(name: name)
  end

end

# class Place
#   translates :name, :description, :address, :village, :city

#   belongs_to :provider

#   has_many :user_places
#   has_many :favoriting_users, through: :user_places, source: :user

#   has_many :services

#   has_many :assets

#   has_many :tags
# end
