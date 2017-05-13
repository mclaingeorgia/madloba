class ApplicationMailer < ActionMailer::Base
  def default_url_options(options = {})
    { locale: I18n.locale }
  end
end
