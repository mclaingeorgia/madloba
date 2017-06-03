class NotificationMailer < ActionMailer::Base
  default :from => Rails.application.secrets.notification_email
	layout 'mailer'

  def send_admin_moderations(message)
    @message = message
    mail(:bcc => message.bcc, :subject => message.subject)
  end
  # def send_published_theme(message)
  #   @message = message
  #   mail(:to => "#{message.email}",
  #        :subject => I18n.t("mailer.notification.published_theme.subject"))
  # end
  # def send_published_story(message)
  #   @message = message
  #   mail(:to => "#{message.email}",
  #        :subject => I18n.t("mailer.notification.published_story.subject"))
  # end
  # def send_story_comment(message)
  #   @message = message
  #   mail(:to => "#{message.email}",
  #        :subject => I18n.t("mailer.notification.story_comment.subject"))
  # end
  # def send_story_collaboration(message)
  #   @message = message
  #   mail(:to => "#{message.email}",
		# 	:subject => I18n.t("mailer.notification.story_collaboration.subject"))
  # end
  # def send_processed_videos(message)
  #   @message = message
  #   mail(:to => "#{message.email}",
		# 	:subject => I18n.t("mailer.notification.processed_videos.subject"))
  # end
  # def send_processed_video_errors(message)
  #   @message = message
  #   mail(:bcc => "#{message.bcc}",
		# 	:subject => I18n.t("mailer.notification.processed_video_errors.subject"))
  # end

end
