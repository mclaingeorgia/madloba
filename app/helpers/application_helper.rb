module ApplicationHelper
  RATING_THRESHOLD = 5
  def page_title(page_title)
    content_for(:page_title) { page_title.html_safe }
  end

  def current_url
    "#{request.protocol}#{request.host_with_port}#{request.fullpath}"
  end

  def full_url(path)
    "#{request.protocol}#{request.host_with_port}#{path}"
  end

  # apply the strip_tags helper and also convert nbsp to a ' '
  def strip_tags_nbsp(text)
    if text.present?
      strip_tags(text.gsub('&nbsp;', ' '))
    end
  end
  def controller_name?(name)
    return controller_name == name.to_s
  end
  def action_name?(name)
    return action_name == name.to_s
  end
  def if_path_match(pth, v1, v2 = '')
    return "#{controller_name}/#{action_name}" == pth.to_s ? v1 : v2
  end
  def format_messages(resource)
     # Rails.logger.debug("--------------------format_messages------------------------#{resource.providers.inspect}")
    order_list = resource.class.validation_order_list
    ordered_messages = []
    messages = resource.errors.messages.dup
    joiner = '.<br/>'

    order_list.each {|item|
      if messages.include?(item)
        ordered_messages << resource.errors.full_messages_for(item).join(joiner)
        messages.delete(item)
      end
    }
    messages.keys.sort.each{|item|
      ordered_messages << resource.errors.full_messages_for(item).join(joiner)
    }
    ordered_messages.join(joiner)
  end
  def set_user_return_to
    session[:user_return_to] = current_url
    # Rails.logger.debug("--------------------------------------------#{current_url}")
     # # user_return_to
  end

  def set_flash(response, now = true)
    type = response[:type]
    text = response[:text]
    if [:success, :notice, :error, :alert].index(type).present?
      text_str = t("messages.#{text}", response[:action].present? ? {action: t("messages.#{response[:action]}")} : {})

      if now
        flash.now[type] = text_str
      else
        flash[type] = text_str
      end

    end
    response[:forward]
  end

  def custom_label(str, required = false)
    required_str = required ? '<abbr title="required">*</abbr>' : ''
    "#{str}#{required_str.html_safe}:"
  end

  def user_guest?
    current_user.nil?
  end

  def user_user?
    current_user.present? && current_user.user?
  end

  def user_provider?
    current_user.present? && current_user.provider?
  end
  def user_admin?
    current_user.present? && current_user.admin?
  end
  # def resource_name
  #   :user
  # end

  # def resource
  #   @resource ||= User.new
  # end

  # def devise_mapping
  #   @devise_mapping ||= Devise.mappings[:user]
  # end


  # def site_name
  #   Rails.cache.fetch(CACHE_APP_NAME) {Setting.find_by_key(:app_name).value}
  # end

  # def site_city
  #   Rails.cache.fetch(CACHE_CITY_NAME) {Setting.find_by_key(:city).value}
  # end

  # def site_country
  #   Rails.cache.fetch(CACHE_COUNTRY_NAME) {Setting.find_by_key(:country).value}
  # end

  # # Maximum number of days an post can be published for.
  # def max_number_days_publish
  #   Rails.cache.fetch(CACHE_MAX_DAYS_EXPIRE) {Setting.find_by_key(:post_max_expire).value}
  # end

  # # Regardless of what the current navigation state is, we need store all the item names into an array, in order to make the type-ahead of the item search bar work.
  # def all_posts_items
  #   Post.joins(:item).pluck(:name).uniq
  # end

  # # Checks if we're on the Madloba demo website
  # def demo?
  #   request.original_url.include? 'demo.madloba.org'
  # end


  # # methods for model-related controller (location, item, category, post)
  # # --------------------------------------------------------------------
  # def requires_user
  #   if !user_signed_in?
  #     redirect_to '/user/login'
  #   end
  # end

  # def record_not_found
  #   flash[:error] = t('home.record_not_exist')
  #   if current_user && current_user.admin?
  #     redirect_to user_managerecords_path
  #   else
  #     redirect_to root_path
  #   end
  # end

  # # display user's locations, to allow them to tie existing one to an post.
  # def user_locations_number
  #   if (current_user && current_user.locations)
  #     current_user.locations.count
  #   else
  #     0 # no registered user, or registered user with no locations.
  #   end
  # end

  # # Defines whether or not the user is on the admin panel.
  # # That will have an impact on the bootstrap class used for the navigation, for example
  # def admin_panel?
  #   (request.original_url.include? '/user') && (current_user)
  # end

  # # Defines whether or not the user is going through the setup pages.
  # # That will have an impact on the content of the navigation bar.
  # def setup_mode?
  #   request.original_url.include? '/setup'
  # end

  # def navigation_madloba_icon_path
  #   setup_mode? ? setup_path : root_path
  # end

  # def madloba_logo_file_name
  #   admin_panel? ? 'madloba_logo_green_40.png' : 'madloba_logo_50.png'
  # end

  # def navigation_madloba_title
  #   setup_mode? ? I18n.t('setup.madloba_setup') : site_name
  # end

  # def about_path_to_use
  #   (current_page?(root_url) || current_page?('/search')) ? '#' : about_path
  # end







  # def valid_float?(str)
  #   # The double negation turns this into an actual boolean true - if you're
  #   # okay with "truthy" values (like 0.0), you can remove it.
  #   !!Float(str) rescue false
  # end

  # def is_devise_message(msg)
  #   msg == t('devise.registrations.signed_up_but_unconfirmed')
  # end

  # def notifications_for(notice)
  #   # We're not displaying any Devise notification during the setup screens
  #   return {message: notice, alert: 'success'} if notice.present? && !(request.original_url.include? 'setup')
  #   {message: '', alert: ''}
  # end


  # private

  # # Define whether the app is deployed on Heroku or not.
  # def on_heroku?
  #   ENV['MADLOBA_IS_ON_HEROKU'].downcase == 'true'
  # end

  # def region_list
  #   [
  #       [t('region.tbilisi'), 'Tbilisi'],
  #       [t('region.guria'), 'Guria'],
  #       [t('region.imereti.'), 'Imereti'],
  #       [t('region.kakheti'), 'Kakheti'],
  #       [t('region.kvemo_kartli'), 'Kvemo Kartli'],
  #       [t('region.kazbegi'), 'Kazbegi'],
  #       [t('region.mtskheta_mtianeti'), 'Mtskheta Mtianeti'],
  #       [t('region.racha'), 'Racha'],
  #       [t('region.svaneti'), 'Svaneti'],
  #       [t('region.samegrelo'), 'Samegrelo'],
  #       [t('region.samtskhe_javakheti'), 'Samtskhe Javakheti'],
  #       [t('region.shida_kartli'), 'Shida Kartli'],
  #       [t('region.adjara'), 'Adjara'],
  #       [t('region.abkhazia'), 'Abkhazia'],
  #       [t('region.khevsureti'), 'Khevsureti'],
  #       [t('region.tusheti'), 'Tusheti'],
  #       [t('region.south_osettia'), 'South Osettia']
  #   ]
  # end
  def rating_threshold
    return RATING_THRESHOLD
  end
  def clean_string(str)
    str.nil? ? '' : str.squeeze(' ').strip.chomp(',')
  end
  def clean_string_from_spaces(str)
    str.nil? ? '' : str.squeeze(' ').strip
  end
  # creates full address string from street_number, street_name, village, city,
  # region with Georgia at the end. Two versions returned with and without street_number
  # with village if provided
  def assemble_address(parts)
    lookup = []
    [:street_name, :village, :city, :region].each{ |part|
      next if part == :village && !parts[:village].present?
      lookup.push(clean_string(parts[part]))
    }
    lookup = lookup.push('Georgia').join(', ')
    ["#{clean_string(parts[:street_number])} #{lookup}", lookup]

  end

  def geocodes_from_address(address)
    # puts "------------------------address--#{address}"
    response = nominatim_ws_response_for(address)
    if response && response[0]
        rsp = response[0]
        if (rsp['lat'] && rsp['lon'])
          return [rsp['lat'], rsp['lon']]
        end
    end
    return nil
  end
  # # Helpers for map related pages
  # # -----------------------------
  def nominatim_ws_response_for(location)
    url = ENV['OSM_NOMINATIM_URL'] % {location: location, language: I18n.locale}
    safeurl = URI.parse(URI.encode(url))
    response = HTTParty.get(safeurl)
    # puts "---------#{response.inspect}"
    response.success? ? response : nil
  end
  # def address_from_geocodes(latitude,longitude)
  #   url = "http://open.mapquestapi.com/nominatim/v1/reverse.php?format=json&lat=#{latitude}&lon=#{longitude}"
  #   safeurl = URI.parse(URI.encode(url))
  #   response = HTTParty.get(safeurl)
  #   raise response.response unless response.success?
  #   response['display_name']
  # end
end
