class ApplicationMailer < ActionMailer::Base
  default :from => Rails.application.secrets.notification_email
  layout 'mailer'

  def default_url_options(options = {})
    { locale: I18n.locale }
  end

  def send_contact_message(message)
    @message = message
    mail(:bcc => message.bcc, :subject => message.subject) do |format|
      format.html { render 'mailers/application/send_contact_message' }
      format.text { render 'mailers/application/send_contact_message' }
    end
  end
end
