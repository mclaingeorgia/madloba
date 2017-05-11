class TranslationPresenceValidator < ActiveModel::EachValidator
  LOCALES = [:en]

  def validate_each(record, attribute, value)
    if values_for_locales(record, attribute).any?(&:blank?)
      record.errors.add attribute, options[:message] || :blank
    end
  end

private
  def values_for_locales(record, attribute)
    LOCALES.map { |locale| record.read_attribute(attribute, locale: locale) }
  end
end
