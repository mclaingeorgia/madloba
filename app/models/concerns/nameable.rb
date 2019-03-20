module Nameable
  extend ActiveSupport::Concern

  included do
    def self.human(count = 1)
      model_name.human(count: count)
    end
    def self.human_attribute(attribute, colon = true, required = false)
      (self.human_attribute_name(attribute) + (required ? "<abbr title='#{I18n.t('simple_form.required.text')}'>#{I18n.t('simple_form.required.mark')}</abbr>" : '' ) + (colon ? ':' : '')).html_safe
    end
  end
end


