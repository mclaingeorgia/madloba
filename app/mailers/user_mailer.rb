class UserMailer < ActionMailer::Base
  default from: Rails.application.secrets.notification_email

  include ApplicationHelper

  # When an ad is created, this method sends an e-mail to the user who just created it.
  def created_ad(user_info, ad, url)
    @ad = ad
    @full_admin_url = url
    @user = user_info
    @site_name = site_name
    mail(to: user_info[:email], subject: t('mailer.new_ad_object', site_name: site_name, ad_title: ad.title))
  end

  # Notifying the super-admins when a new ad has been created.
  def created_ad_notify_super_admins(user_info, ad, super_admins)
    @ad = ad
    @user = user_info
    @site_name = site_name
    @ad_edit_path = edit_user_service_path(@ad.id)
    mail(to: super_admins.join(', '), subject: t('mailer.new_ad_to_review', title: ad.title))
  end

  # Notifying super-admins when ad has been updated by a non-super-admin.
  def updated_ad_notify_super_admins (user_info, ad, super_admins)
    @ad = ad
    @user = user_info
    @site_name = site_name
    @ad_edit_path = edit_user_service_path(@ad.id)
    mail(to: super_admins.join(', '), subject: t('mailer.updated_service', title: ad.title))
  end

  # Sends an e-mail to a user, when another user replied to their ad, to be in touch with them.
  def send_message_for_ad(sender, message, ad_info)
    @sender = sender
    @ad = ad_info
    @site_name = site_name
    @message = message
    mail(to: ad_info[:email], reply_to: sender[:email], subject: t('mailer.reply_ad_object', ad_title: ad_info[:title], site_name: site_name))
  end

  # Sends a message to an user, when they've been made admin by a super-admin
  def notify_user_is_admin(recipient)
    new_role = ''
    if recipient[:role] == 'admin'
      new_role = t('admin.profile.admin_user').downcase
    elsif recipient[:role] == 'super_admin'
      new_role = t('admin.profile.super_admin_user').downcase
    end
    @new_role = new_role
    @site_name = site_name
    @user = recipient
    mail(to: recipient[:email], subject: t('mailer.you_are_admin_html', site_name: site_name, new_role: new_role))
  end

end
