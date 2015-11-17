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

    if (params[:lat] && params[:lon])
        # The center of the map is now represented by the searched location.
        @map_settings['lat'] = params[:lat]
        @map_settings['lng'] = params[:lon]

        if params[:loc]
          # A location search was just performed, with the name of the searched location (given back from Nominatim ws) in it.
          current_location = params[:loc]
        else
          # there was no search beforehand, we need to find the address, based on the given latitude and longitude, as parameters.
          current_location = getAddressFromGeocodes(params[:lat], params[:lon])
          if !current_location
            current_location = t('home.default_current_loc')
          end
        end

        @map_settings['searched_address'] = current_location
        @location_search_refinement_to_display = current_location

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
    @locations_exact = Location.search('exact', cat_nav_state, params[:item], selected_item_ids, params[:q], nil)

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
    settings = Setting.where(key: %w(contact_email description))
    settings.each do |setting|
      if setting['key'] == 'description' && setting['value'] != ''
        @website_description_paragraph = setting['value'].split(/[\r\n]+/)
      end
      if setting['key'] == 'contact_email' && setting['value'] != ''
        @contact_email = setting['value']
      end
    end

    render 'home/about'
  end


  # -------------------------
  # Method for the FAQ page
  # -------------------------
  def faq
    render 'home/faq'
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
  def get_link(label, url)
    if label != '' && url != ''
      return {label: label, url: url}
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
      elsif setting['key'] == 'summary'
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
      @links << get_link(settings["link_#{number}_label"], settings["link_#{number}_url"])
    end

    return settings
  end

end
