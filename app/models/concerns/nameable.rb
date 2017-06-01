module Nameable
  extend ActiveSupport::Concern

  included do
    def self.human(count = 1)
      model_name.human(count: count)
    end
    def self.human_attribute(attribute, colon = true)
      self.human_attribute_name(attribute) + (colon ? ':' : '')
    end
  end
end
