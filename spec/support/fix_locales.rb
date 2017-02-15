module FixLocalesSpecs
  module ::ActionController::TestCase::Behavior
    alias_method :process_without_logging, :process

    def process(action, http_method = 'GET', *args)
      e = Array.wrap(args).compact
      e[0] ||= {}
      e[0].merge!({locale: I18n.locale})
      process_without_logging(action, http_method, *e)
    end
  end
end
