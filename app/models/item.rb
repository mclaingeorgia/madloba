class Item < ActiveRecord::Base

  has_many :post_items
  has_many :posts, through: :post_items, dependent: :destroy

  TRANSLATED_FIELDS = [:name, :description]

  before_create :populate_required_fields_missing_translations
  before_save { |item| item.name.downcase! }

  validates :name_ka, presence: true

  # Fields to be translated
  translates *TRANSLATED_FIELDS
  globalize_accessors :locales => I18n.available_locales, :attributes => TRANSLATED_FIELDS


  def populate_required_fields_missing_translations
    default_locale = I18n.default_locale
    other_locales = I18n.without_default_locales

    TRANSLATED_FIELDS.each { |item|
      default_value = self.send("#{item}_#{default_locale}")
      if default_value.present?
        other_locales.each { |locale|
          self.send("#{item}_#{locale}=", default_value) unless self.send("#{item}_#{locale}").present?
        }
      end
    }
  end

  def capitalized_name
    self.name.nil? ? '' : self.name.capitalize
  end

end
