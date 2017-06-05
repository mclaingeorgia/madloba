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
    process_moderator_responses
    process_photo_uploads3
    puts "**************************"
    puts "--> Notification Triggers - process all types end at #{Time.now}"
    puts "**************************"
  end


  TYPES = {
          :admin_moderate_report => 1,
          :admin_moderate_ownership => 2,
          :admin_moderate_new_provider => 3,
          :admin_moderate_tag => 4,
          :moderator_report_response => 5,
          :moderator_ownership_response => 6,
          :moderator_new_provider_response => 7,
          :moderator_tag_response => 8,
          :moderator_photo_response => 9,
          :provider_photo_upload => 10
         }

  def self.add_admin_moderation(type, related_id)
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
      message.subject = "#{I18n.t('app.common.name', locale: :en)} - #{I18n.t('notification.admin_moderate.subject', locale: :en)}"
      message.message = triggers.group_by{|g| g[1]}.map{|k,v| [short_moderation_types[k], v.count]}

      NotificationMailer.send_admin_moderations(message).deliver_now# if !Rails.env.staging?
      # NotificationTrigger.where(id: triggers.map{|m| m[0]}).update_all(:processed => true)
    end
  end


  def self.add_moderator_response(type, related_id)
    TYPES.include?(type) && NotificationTrigger.create({notification_type: TYPES[type], related_id: related_id})
  end

  def self.process_moderator_responses #
    puts "--> Notification Triggers - process_moderator_responses"
    moderation_types = {
      5 => :moderator_report_response,
      6 => :moderator_ownership_response,
      7 => :moderator_new_provider_response,
      8 => :moderator_tag_response,
      9 => :moderator_photo_response
    }
    short_moderation_types = { 5 => :report, 6 => :ownership, 7 => :new_provider, 8 => :tag, 9 => :photo }

    grouped_triggers = NotificationTrigger.where(notification_type: moderation_types.keys).pending.group_by{|g| short_moderation_types[g.notification_type] }#.map{|k,v| [short_moderation_types[k], v.count]}
    users_triggers = {}
    users_triggers_ids = {}
    grouped_triggers.each do |trigger_type, triggers|
      triggers.each do |trigger|
        if trigger.notification_type == TYPES[:moderator_report_response]
          item = PlaceReport.find(trigger.related_id)
        elsif trigger.notification_type == TYPES[:moderator_ownership_response]
          item = PlaceOwnership.find(trigger.related_id)
        elsif trigger.notification_type == TYPES[:moderator_new_provider_response]
          item = Provider.find(trigger.related_id)
        elsif trigger.notification_type == TYPES[:moderator_tag_response]
          item = Tag.find(trigger.related_id)
        elsif trigger.notification_type == TYPES[:moderator_photo_response]
          item = Upload.find(trigger.related_id)
        end

        if users_triggers[item.user_id].nil?
          users_triggers[item.user_id] = { }
          users_triggers_ids[item.user_id] = []
        end

        if users_triggers[item.user_id][trigger_type].nil?
          users_triggers[item.user_id][trigger_type] = [item]
        else
          users_triggers[item.user_id][trigger_type] << item
        end
        users_triggers_ids[item.user_id] << trigger.id
      end
    end
    users_triggers.each do |user_id, trigger_by_types|
      user = User.find(user_id)
      message = Message.new
      message.to = Rails.env.staging? ? User.admin_emails : user.email
      message.subject = "#{I18n.t('app.common.name', locale: :en)} - #{I18n.t('notification.moderator_response.subject', locale: :en)}"
      message.message = trigger_by_types
      NotificationMailer.send_moderator_responses(user, message).deliver_now# if !Rails.env.staging?
      NotificationTrigger.where(id: users_triggers_ids[user_id]).update_all(:processed => true)

    end
  end


  def self.add_photo_upload(type, related_id)
    TYPES.include?(type) && NotificationTrigger.create({notification_type: TYPES[type], related_id: related_id})
  end

  def self.process_photo_uploads
    puts "--> Notification Triggers - process_photo_uploads"
    moderation_types = { 10 => :provider_photo_upload }
    short_moderation_types = { 10 => :photo_upload }

    triggers = NotificationTrigger.where(notification_type: moderation_types.keys).pending
    places_uploads = {}
    places_uploads_ids = {}
    triggers.each do |trigger|
      item = Upload.find(trigger.related_id)

      if places_uploads[item.place_id].nil?
        places_uploads[item.place_id] = []
        places_uploads_ids[item.place_id] = []
      end

      places_uploads[item.place_id] << item
      places_uploads_ids[item.place_id] << trigger.id
    end

    places_uploads.each do |place_id, place_uploads|
      place = Place.find(place_id)
      if place.emails.present?
        message = Message.new
        message.to = Rails.env.staging? ? User.admin_emails : place.emails.join(';')
        message.subject = "#{I18n.t('app.common.name', locale: :en)} - #{I18n.t('notification.photo_upload.subject', locale: :en)}"
        message.message = place_uploads
        NotificationMailer.send_photo_uploads(place, message).deliver_now# if !Rails.env.staging?
        NotificationTrigger.where(id: places_uploads_ids[place_id]).update_all(:processed => true)
      end

    end
  end
end
