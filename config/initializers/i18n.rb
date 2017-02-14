module I18n
  def without_default_locales
    self.available_locales - [ self.default_locale ]
  end
  module_function :without_default_locales
end
