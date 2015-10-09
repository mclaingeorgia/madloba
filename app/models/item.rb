class Item < ActiveRecord::Base

  has_many :ad_items
  has_many :ads, through: :ad_items, dependent: :destroy

  # Fields to be translated
  translates :name, :description
  globalize_accessors :locales => [:en, :ka], :attributes => [:name, :description]

  validates :name, presence: true

  before_save { |item| item.name.downcase! }

  # Capitalized only the first letter of the item name
  def capitalized_name
    self.name.slice(0,1).capitalize + self.name.slice(1..-1)
  end

end
