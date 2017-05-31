module Nameable
  extend ActiveSupport::Concern

  included do
    def self.human(count = 1)
      model_name.human(count: count)
    end
  end
end
