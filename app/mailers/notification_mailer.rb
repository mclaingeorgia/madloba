class NotificationMailer < ActionMailer::Base
  default :from => Rails.application.secrets.notification_email
	layout 'mailer'

  def send_admin_moderations(message)
    @message = message
    mail(:bcc => message.bcc, :subject => message.subject) do |format|
      format.html { render 'mailers/notification/send_admin_moderations' }
      format.text { render 'mailers/notification/send_admin_moderations' }
    end
  end

  def send_moderator_responses(user, message)
    @message = message
    @user = user
    mail(:to => message.to, :subject => message.subject) do |format|
      format.html { render 'mailers/notification/send_moderator_responses' }
      format.text { render 'mailers/notification/send_moderator_responses' }
    end
  end

  def send_photo_uploads(place, message)
    @message = message
    @place = place
    mail(:to => message.to, :subject => message.subject) do |format|
      format.html { render 'mailers/notification/send_photo_uploads' }
      format.text { render 'mailers/notification/send_photo_uploads' }
    end
  end

  def place_change(place, message)
    @message = message
    @place = place
    mail(:to => message.to, :subject => message.subject) do |format|
      format.html { render 'mailers/notification/place_change' }
      format.text { render 'mailers/notification/place_change' }
    end
  end



end
