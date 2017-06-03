class NotificationTrigger < ActiveRecord::Base
  # attr_accessible :notification_type, :identifier, :processed
  scope :pending, -> { where(processed: false) }

  # What  When Send To Who
  # new user registration immediately to new user
  # place contact form  immediately to user/place email
  #
  #
  #
  # new service provider  every hour  to admin moderators
  # report  every hour  to admin moderators
  # Take ownership  every hour  to admin moderators
  # new place tags  every hour  to admin moderators
  #
  # user upload image every hour  to place moderators
  # service provider moderated  every hour  to user
  # report moderated  every hour  to user
  # ownership moderated every hour  to user
  # image moderated every hour  to user
  def self.process_all_types
    puts "**************************"
    puts "--> Notification Triggers - process all types start at #{Time.now}"
    puts "**************************"
    process_admin_moderations
    # process_new_user
    # process_published_theme
    # process_story_collaboration
    # process_story_comment
    puts "**************************"
    puts "--> Notification Triggers - process all types end at #{Time.now}"
    puts "**************************"
  end


  TYPES = {:admin_moderate_report => 1, :admin_moderate_ownership => 2, :admin_moderate_new_provider => 3,
           :admin_moderate_tag => 3}



  def self.add_admin_moderation(type, related_id)
    # Rails.logger.debug("--------------------------------------------#{type} #{related_id}")
    TYPES.include?(type) && NotificationTrigger.create({notification_type: TYPES[type], related_id: related_id})
  end

  def self.process_admin_moderations
    puts "--> Notification Triggers - process_admin_moderations"
    moderation_types = { 1 => :admin_moderate_report, 2 => :admin_moderate_ownership, 3 => :admin_moderate_new_provider, 4 => :admin_moderate_tag }
    short_moderation_types = { 1 => :report, 2 => :ownership, 3 => :new_provider, 4 => :tag }

    triggers = NotificationTrigger.where(notification_type: moderation_types.keys).pending.pluck(:id, :notification_type)#.group_by{|g| g[1]}

    if triggers.present?
      message = Message.new
      message.bcc = User.admin_emails
      message.subject = "#{I18n.t('app.common.name')} - #{I18n.t('notification.admin_moderate.subject')}"
      message.message = triggers.group_by{|g| g[1]}.map{|k,v| [short_moderation_types[k], v.count]}

      NotificationMailer.send_admin_moderations(message).deliver_now# if !Rails.env.staging?
      # NotificationTrigger.where(id: triggers.map{|m| m[0]}).update_all(:processed => true)
    end
  end



end
