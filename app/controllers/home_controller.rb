class HomeController < ApplicationController
  include ApplicationHelper

  # --------------------------------------
  # Method for the main screen (home page)
  # --------------------------------------
  def index
    # Initializing the map, in relation to its center, defined in the settings table.
    # Map on the home page does not focus on 1 specific marker, and is not clickable (ie no marker appears on clicl on the map)
    @map_settings = getMapSettings(nil, HAS_NOT_CENTER_MARKER, NOT_CLICKABLE_MAP)

    # Initializing links, and social media information, for the footer of the home page.
    settings = get_footer_info

    # We check if the user searched for an item and/or a location
    if params[:item] && params[:item] != ''
      # An item is being searched.
      selected_item_ids = Item.joins(:ads).where('name LIKE ?', "%#{params[:item].downcase}%").pluck(:id).uniq
    end

    if (params[:zoom])
      @map_settings['my_zoom'] = params[:zoom]
    end

    if (params[:lat] && params[:lon])
        # The center of the map is now represented by the searched location.
        @map_settings['lat'] = params[:lat]
        @map_settings['lng'] = params[:lon]

        if params[:loc]
          # A location search was just performed, with the name of the searched location (given back from Nominatim ws) in it.
          current_location = params[:loc]
          @map_settings['searched_address'] = current_location
          @location_search_refinement_to_display = current_location
        else
          # there was no search beforehand, we need to find the address, based on the given latitude and longitude, as parameters.
          #current_location = getAddressFromGeocodes(params[:lat], params[:lon])
          #if !current_location
            #current_location = t('home.default_current_loc')
          #end
        end

    end

    # Defining all the categories attached to an item.
    if selected_item_ids
      # We select here only the categories, based on the items found after a search.
      @categories = Category.joins(ads: :items).where("items.id IN (?)", selected_item_ids).order('name asc').uniq
    else
      # We select the categories related to all available items
      @categories = Category.joins(:ads).order('name asc').uniq
    end

    # We need to see if we have a navigation state.
    # If we do, that will impact what will be displayed on the map.
    if params[:cat]
      cat_nav_state = params[:cat].split(" ")
    end

    # We need to see if we have a navigation state.
    # If we do, that will impact what will be displayed on the map.
    if params[:cat]
      cat_nav_state = params[:cat].split(" ")
    end

    # Queries to get ads to be displayed on the map, based on their locations
    # First, we get the ads tied to an exact location.
    @locations_exact = Ad.search(cat_nav_state, params[:item], selected_item_ids, params[:q], nil)

    area_types = settings['area_type'].split(',')
    if area_types.include?('postal')
      # If the users have the possiblity to post ad linked to a postal code, we get here these type of ads.
      @locations_postal = Location.search('postal', cat_nav_state, params[:item], selected_item_ids, params[:q], nil)
    end
    if area_types.include?('district')
      # If the users have the possiblity to post ad linked to a pre-defined district, we also get here these type of ads.
      @locations_district = Location.search('district', cat_nav_state, params[:item], selected_item_ids, params[:q], nil)
    end

    # Getting a hash that matches areas to their respective latitude and longitudes.
    if area_types.include?('postal') || area_types.include?('district')
      @area_geocodes = Location.define_area_geocodes(@locations_postal, @locations_district)
    end
  end


  # -------------------------
  # Method for the About page
  # -------------------------
  def about
    keys = %w(contact_email)
    description_key = "description_#{I18n.locale.to_s}"
    keys << description_key
    settings = Setting.where(key: keys)
    settings.each do |setting|
      if setting['key'] == description_key && setting['value'] != ''
        @website_description_paragraph = setting['value'].split(/[\r\n]+/)
      end
      if setting['key'] == 'contact_email' && setting['value'] != ''
        @contact_email = setting['value']
      end
    end

    render 'home/about'
  end

  def tos
    if current_user.nil? || (current_user && current_user.has_agreed_to_tos)
      redirect_to root_path
    end
    render 'home/tos'
  end

  def update_tos
    if params['has_agreed_to_tos'].nil? || params['has_agreed_to_tos'] == false
      flash[:error] = t('admin.profile.please_agree')
      redirect_to tos_path
    else
      current_user.has_agreed_to_tos = true
      current_user.save
      redirect_to user_path
    end
  end

  # -------------------------
  # Method for the FAQ page
  # -------------------------
  def faq
    render 'home/faq'
  end

  # Method called by Ajax call made when marker on the home page is clicked.
  # Returns the HTML code that will create the popup linked to that marker.
  def show_ad_popup

    popup_html = ''

    begin
      ad_id = params['ad_id']
      location_id = params['location_id']
      category_id = params['category_id']
      page = params['page']

      ad = Ad.joins([:translations, {locations: :translations}, {categories: :translations}]).where(id: ad_id).first
      number_of_categories = ad.categories.count

      popup_html = "<div style='overflow: auto;'>"

      # Title (and image when available)
      if ad.image?
          popup_html += "<div class='col-xs-12 col-md-6 title_popup'>#{view_context.link_to(ad.title, service_path(ad.id))}</div>
                         <div class='col-xs-12 col-md-6'>#{ActionController::Base.helpers.image_tag(ad.image.thumb.url, class: 'pull-right')}</div>"
      else
          popup_html += "<div class='col-xs-12 title_popup'>#{view_context.link_to(ad.title, service_path(ad.id))}</div>"
      end

      # Service types
      service_type = t('admin.ads')
      items = ad.items.map(&:name).join(', ')
      popup_html += "<div class='col-xs-12' style='margin-top: 15px;'>#{service_type}: #{items}</div>"

      # Service categories
      ad_action = t('admin.categories')
      category_name = ''
      ad.categories.each do |category|
        if category.id == category_id.to_i
          category_name = "<span style='color:" + MARKER_COLORS[category.marker_color] + "';><strong>" + category.name + "</strong></span>";
          break
        end
      end
      and_other_categories = ''
      if number_of_categories > 1
        and_other_categories = "and #{number_of_categories - 1} other categorie(s)"
      end
      popup_html += "<div class='col-xs-12'>#{ad_action}: #{category_name} #{and_other_categories}</div>"

      # Location full address
      location = ''
      ad.locations.each do |loc|
        if loc.id == location_id.to_i
          location = loc.name_and_or_full_address
        end
      end
      popup_html += "<div class='col-xs-12' style='margin: 15px 0px;'>#{location}</div>"

      if page == HOME_PAGE
        # "Show details" button
        popup_html += "<div class='col-xs-12' style='text-align: center'>#{view_context.link_to(t('home.show_details'), service_path(ad.id), class: 'btn btn-info btn-sm no-color' )}</div>"
      end

      popup_html += "</div>"

    rescue Exception => e
      p e
      p e.backtrace
      # An error occurred, we show a error message.
      popup_html = "<i>#{t('home.error_get_popup_content')}</i>"
    end

    render json: popup_html
  end

  # Ajax call to show the ads related to 1 type of item and to 1 district/area.
  # Call made when click on link, in area marker popup.
  def showSpecificAds
    item_name = params['item']
    location_type = params['type'] # 'postal', or 'district'
    area_value = params['area'] # code postal area code, or district id
    ads = Ad.joins(:location, :items).where('expire_date >= ? AND locations.loc_type = ? AND items.name = ?', Date.today, location_type, item_name)
    item = Item.joins(:category).where('items.name = ?', item_name).first

    result = {}
    if location_type == 'postal'
      ads = ads.where('locations.postal_code LIKE ?', "#{area_value}%")
      result['area_name'] = area_value
    elsif location_type == 'district'
      ads = ads.where('locations.district_id = ?', area_value)
      result['area_name'] = District.find(area_value).name
    end

    if item
      result['icon'] = item.category.icon
      result['hexa_color'] = item.category.marker_color_hexacode
    end

    result['ads'] = []
    ads.each do |ad|
      result['ads'] << {id: ad.id, title: ad.title, is_giving: ad.is_giving}
    end

    render json: result
  end

  private


  # Creates a hash with the link and the label of one "Useful link",
  # that appears at the center of the home page footer.
  def get_link(label, label_ka, url)
    if label != '' && url != ''
      return {'label_en': label, 'label_ka': label_ka, 'url': url}
    end
  end

  # Get information ready for the footer of the home page
  # (eg. Website description, contact email, social media links... )
  # Also returns a settings hash, that will be needed for the rest of HomeController#index execution.
  def get_footer_info
    @social_medias = []
    settings = {}
    Setting.all.each do |setting|
      if %w(facebook twitter pinterest).include? setting['key']
        # Website's social media
        social = {}
        if setting['value'] != ''
          social['name'] = setting['key']
          social['url'] = setting['value']
          @social_medias << social
        end
      elsif setting['key'] == "summary_#{I18n.locale}"
        # Website summary
        @website_description_paragraph = []
        if setting['value'] && setting['value'].length > 0
          @website_description_paragraph = setting['value'].split(/[\r\n]+/)
        end
      elsif setting['key'] == 'contact_email'
        @contact_email = setting['value']
      else
        # Settings hash
        settings[setting['key']]=setting['value']
      end
    end

    # Useful links, for the footer section.
    link_numbers = %w(one two three four five six)
    @links = []
    link_numbers.each do |number|
      @links << get_link(settings["link_#{number}_label"], settings["link_#{number}_label_ka"], settings["link_#{number}_url"])
    end

    return settings
  end

end
