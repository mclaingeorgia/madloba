module User::PostsHelper

  # All items from the database, for the item field, in the New post form
  def all_items
    Item.pluck(:name)
  end

  # Checks if current user owns this post.
  def is_owning(post)
    current_user && current_user.owns_post?(post)
  end

  # Checks if anonymous user who posted an post added their email address.
  # If they did, users will be able to send them a message about this post.
  def anon_user_puts_email(post)
    current_user == nil && post.anon_email != nil
  end

  # Checks if image upload is allowed
  def can_upload_image
    image_storage = Rails.cache.fetch(CACHE_IMAGE_STORAGE) {Setting.find_or_create_by(key: 'image_storage').value}
    (image_storage == IMAGE_ON_SERVER || image_storage == IMAGE_AMAZON_S3)
  end

  def publisher_name(post)
    publisher_name = ''
    if post.is_anonymous
      publisher_name = post.anon_name
    else
      post_user = post.user
      if post.username_used?
        publisher_name = post_user.username
      else
        post_user = post.user
        if post.username_used?
          publisher_name = post_user.username
        else
          publisher_name = "#{post_user.first_name} #{post_user.last_name}"
        end
      end
    end
    publisher_name
  end

  # When an ad-related page loads, the associated image might still be processed, or being uploaded to S3.
  # This method checks if the normal image is available yet.
  def is_image_available(post)
    post.image && (post.image.versions)[:normal].file.present? && (post.image.versions)[:normal].file.exists?
  end

  # Getting the maximum number of days of publication, before post expires.
  def max_expire_days
    Setting.where(key: 'post_max_expire').pluck(:value).first
  end

  # If a signed-in user is creating an post, they will have the choice to create a new location
  # or to choose one of their existing location (registered when creating other posts before).
  def can_choose_existing_locations(current_user)
    current_user != nil && current_user.locations.length > 0
  end

  def funding_source
    [[t('post.funding_private'), 'private'],[t('post.funding_municipality'),'municipality'],[t('post.funding_government'),'governmental'],[t('post.funding_other'),'other']]
  end

  def beneficiaries_age_group
    [['0-7','0-7'],
     ['6-18','6-18'],
     ['18-29','18-29'],
     ['0-18', '0-18'],
     ['0-29', '0-29'],
     ['29+', '29+']]
  end

  def service_provider_legal_form
    [[t('post.municipal_type'), 'municipal'], [t('post.government_type'), 'governmental'],
     [t('post.ngo_type'), 'ngo'], [t('post.inter_ngo_type'),'inter-ngo'], [t('post.disabled_org'),'disabled'],
     [t('post.local_org'),'local'], [t('post.private_type'),'private'],
     [t('post.community_org'),'community'], [t('post.other'),'other']]
  end

  def check_additional_phone_numbers(loc)
    result = nil
    array = []
    if loc.add_phone_number
      array << loc.add_phone_number
    end
    if loc.add_phone_number_2
      array << loc.add_phone_number_2
    end

    if !array.empty?
      result = array.join(', ')
    end

    return result
  end

  def contact_email_to_show(post)
    email = ''
    if post.user
      email = post.user.email
    elsif post.anon_email
      email = post.anon_email
    end
    return email
  end

  def expire_date_for(post)
    return '' if post.expire_date.to_s == '2100-01-01'

    if Date.today > post.expire_date
      I18n.t('post.has_expired', expire_date: post.expire_date.to_s)
    elsif Date.today < post.expire_date
      I18n.t('post.expiration_date', expire_date: post.expire_date.to_s)
    else
      I18n.t('post.expires_today')
    end
  end

  def expire_date_for_new_post
    max_expire_days.to_i > 0 ? t('post.once_created_expire_html', max_expire_days: max_expire_days) : ''
  end

end
