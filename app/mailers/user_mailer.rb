class UserMailer < ActionMailer::Base
  default from: Rails.application.secrets.notification_email

  include ApplicationHelper

  # When an post is created, this method sends an e-mail to the user who just created it.
  def created_ad(user_info, post, url)
    @post = post
    @full_admin_url = url
    @user = user_info
    @site_name = site_name
    mail(to: user_info[:email], subject: t('mailer.new_post_object', site_name: site_name, post_title: post.title))
  end

  # Notifying the super-admins when a new post has been created.
  def created_post_notify_super_admins(user_info, post, super_admins)
    @post = post
    @user = user_info
    @site_name = site_name
    @post_edit_path = edit_user_service_path(@post.id)
    mail(to: super_admins.join(', '), subject: t('mailer.new_post_to_review', title: post.title))
  end

  # Notifying super-admins when post has been updated by a non-super-admin.
  def updated_post_notify_super_admins (user_info, post, super_admins)
    @post = post
    @user = user_info
    @site_name = site_name
    @post_edit_path = edit_user_service_path(@post.id)
    mail(to: super_admins.join(', '), subject: t('mailer.updated_service', title: post.title))
  end

  # Sends an e-mail to a user, when another user replied to their post, to be in touch with them.
  def send_message_for_ad(sender, message, post_info)
    @sender = sender
    @post = post_info
    @site_name = site_name
    @message = message
    mail(to: post_info[:email], reply_to: sender[:email], subject: t('mailer.reply_post_object', post_title: post_info[:title], site_name: site_name))
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

  def send_welcome_message(email, password)
    @user_email = email
    @password = password

    mail(to: @user_email, subject: "Welcome to RehabGe")
  end

end
