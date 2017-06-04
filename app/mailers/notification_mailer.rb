class NotificationMailer < ActionMailer::Base
  default :from => Rails.application.secrets.notification_email
	layout 'mailer'

  def send_admin_moderations(message)
    @message = message
    mail(:bcc => message.bcc, :subject => message.subject)
  end

  def send_moderator_responses(user, message)
    @message = message
    @user = user
    mail(:to => message.to, :subject => message.subject)
  end

end
