class HomeController < ApplicationController
  include ApplicationHelper

  # --------------------------------------
  # Method for the main screen (home page)
  # --------------------------------------
  def index
    # Initializing the map, in relation to its center, defined in the settings table.
    @map_settings = MapInfo.new.to_hash

    # Initializing links, and social media information, for the footer of the home page.
    settings = get_footer_info

    # We check if the user searched for an item and/or a location
    if params[:item] && params[:item] != ''
      # An item is being searched.
      selected_item_ids = Item.joins(:posts).where('name LIKE ?', "%#{params[:item].downcase}%").pluck(:id).uniq
    end

    if (params[:zoom])
      @map_settings['my_zoom'] = params[:zoom]
    end

    # Defining all the categories attached to an item.
    # if selected_item_ids
    #   # We select here only the categories, based on the items found after a search.
    #   @categories = Category.joins(posts: :items).where("items.id IN (?)", selected_item_ids).order('name asc').uniq
    # else
    #   # We select the categories related to all available items
    #   @categories = Category.joins(:posts).order('name asc').uniq
    # end
    @categories = []

    # We need to see if we have a navigation state.
    # If we do, that will impact what will be displayed on the map.
    if params[:cat]
      cat_nav_state = params[:cat].split(" ")
    end

    # We need to see if we have a navigation state. If we do, that will impact what will be displayed on the map.
    cat_nav_state = params[:cat].split(" ") if params[:cat]

    # Queries to get posts to be displayed on the map, based on their locations
    location_search_result_objects(params, cat_nav_state, selected_item_ids, settings)
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

  # ------------------
  # Search result page
  # ------------------
  def results
    id = params[:area].to_i
    @posts = Post.includes(:location).where(locations: {area_id: id})
               .paginate(page: params[:page] || 1, per_page: 10 )

    @area = Area.find(id)
    render 'home/results'
  end

  # Method called by Ajax call made when marker on the home page is clicked.
  # Returns the HTML code that will create the popup linked to that marker.
  def show_post_popup
    popup_html = ''
    begin
      post_id = params['post_id']
      location_id = params['location_id']
      category_id = params['category_id']

      post = Post.joins([:translations, {locations: :translations}, {categories: :translations}]).where(id: post_id).first
      category = Category.find(category_id)
      location = Location.find(location_id)

      item_count = post.items.count

      title = post.title.length > 40 ? post.title.chomp(a[-3..-1]) + '...' : post.title


      popup_html = "<div style='overflow: auto;'>"
      popup_html += "<div class='col-xs-12 title-popup' style='background-color: #{category.color_code}'>" +
                    "<span>#{title.capitalize}</span></div>"

      if post.image?
        image_tag = ActionController::Base.helpers.image_tag(post.image.normal.url)
        popup_html += "<div class='col-xs-12 image-popup no-padding'>#{image_tag}</div>"
      end

      # Title
      popup_html += "<div class='col-xs-12' style='margin-top: 15px;'>#{view_context.link_to(post.title, service_path(post))}</div>"

      # Action (giving away or searching for) + item name
      item_name = "<span style='color:" + category.color_code + "';><strong>" + category.name + "</strong></span>";
      and_other_items = item_count > 1 ? "and #{item_count  - 1} other item(s)" : ''

      popup_html += "<div class='col-xs-12' style='margin-top: 15px;'>#{item_name} #{and_other_items}</div>"

      # Location full address
      popup_html += "<div class='col-xs-12' style='margin-bottom: 15px;'>#{location.full_address}</div>"

      # "Show details" button
      button = view_context.link_to(t('home.show_details'), service_path(post), class: 'btn btn-info btn-sm no-color' )
      popup_html += "<div class='col-xs-12 button-popup'>#{button}</div>"

      popup_html += "</div>"

    rescue Exception => e
      p e
      p e.backtrace
      # An error occurred, we show a error message.
      popup_html = "<i>#{t('home.error_get_popup_content')}</i>"
    end

    render json: popup_html
  end

  def show_area_popup
    popup_html = ''
    begin
      area_id = params['area_id']

      area = Area.includes(locations: {posts: :items}).find(area_id.to_i)
      post_count, item_count = 0, 0

      # Counting items for all posts in this area.
      area.locations.each do |location|
        post_count += location.posts.count
        location.posts.each{|post| item_count += post.items.count}
      end

      message = I18n.t("home.area_marker_message", post_count: post_count, item_count: item_count)

      popup_html = "<div style='overflow: auto;'>"

      # Title
      popup_html += "<div class='col-xs-12 title-popup' style='background-color: #{Area::AREA_COLOR}'>" +
          "<span>#{area.name}</span></div>"

      # Message
      popup_html += "<div class='col-xs-12' style='margin: 15px 0px;'>#{message}</div>"

      # "Show details" button
      button = view_context.link_to(I18n.t('home.show_results'), results_path(area: area_id), class: 'btn btn-info btn-sm no-color' )
      popup_html += "<div class='col-xs-12 button-popup'>#{button}</div>"

      popup_html += "</div>"

    rescue Exception => e
      logger.error e.message
      logger.error e.backtrace.join("\n")
      # An error occurred, we show a error message.
      popup_html = "<i>#{t('home.error_get_popup_content')}</i>"
    end
    
    render json: popup_html
  end

  def show_location_popup(content)
    popup_html = "<div style='overflow: auto;'>"

    # Title
    popup_html += "<div class='col-xs-12 title-popup' style='background-color: #{Area::AREA_COLOR}'>" +
        "<span>#{t('home.your_searched_location')}</span></div>"
    # Message
    popup_html += "<div class='col-xs-12' style='margin: 15px 0px;'>#{content}</div>"
    popup_html += "</div>"

    popup_html
  end

  def refine_state
    # From the home page, based on the selected navigation, get the relevant posts.

    state = params[:state]

    new_nav_states = state.split('&')
    nav_params = {}
    new_nav_states.each do |state|
      info = state.split('=')
      nav_params[info[0]] = info[1]
    end

    if nav_params['cat'] && nav_params['cat'] != ''
      selected_categories = nav_params['cat'].split('+')
    end

    if nav_params['item'] && nav_params['item'] != ''
      selected_item_ids = []

      # An item is being searched.
      searched_item = nav_params['item']
      selected_item_ids = Item.joins(:posts).where('name LIKE ?', "%#{searched_item}%").pluck(:id).uniq
    end

    response = {}
    response['map_info'] = {}
    response['map_info']['markers'] = Post.search(selected_categories, searched_item, selected_item_ids, nav_params[:q], nil)

    #response['map_info']['area'] = Location.search('area', selected_categories, searched_item, selected_item_ids, nav_params[:q])
    #response['map_info']['area'] = Area.search(selected_categories, selected_item_ids, nav_params[:q])

    render json: response.to_json(:include => { :posts => { :include =>  {:items => { :include => :category }}}})
  end

  # Ajax call to show the posts related to 1 type of item and to 1 area
  # Call made when click on link, in area marker popup.
  def showSpecificAds
    item_name = params['item']
    location_type = params['type'] # 'postal', or 'area'
    area_value = params['area'] # code postal area code, or area id
    posts = Post.joins(:location, :items).where('expire_date >= ? AND  items.name = ?', Date.today, location_type, item_name)
    item = Item.joins(:category).where('items.name = ?', item_name).first

    result = {}
    if location_type == 'postal'
      posts = posts.where('locations.postal_code LIKE ?', "#{area_value}%")
      result['area_name'] = area_value
    elsif location_type == 'area'
      posts = posts.where('locations.area_id = ?', area_value)
      result['area_name'] = Area.find(area_value).name
    end

    if item
      result['icon'] = item.category.icon
      result['hexa_color'] = item.category.marker_color_hexacode
    end

    result['posts'] = []
    posts.each do |post|
      result['posts'] << {id: post.id, title: post.title, giving: post.giving}
    end

    render json: result
  end

  private

  def location_search_result_objects(params, cat_nav_state, selected_item_ids, settings)
    # First, we get the posts tied to an exact location.
    @locations_exact = Post.search(cat_nav_state, params[:item], selected_item_ids, params[:q], nil)

    # If the users have the possiblity to post post linked to a pre-defined area, we also get here these type of posts.
    # locations_area = Location.search('area', cat_nav_state, params[:item], selected_item_ids, params[:q])

    # Getting a hash that matches areas to their respective latitude and longitudes.
    @areas = Area.all.select(:id, :name, :latitude, :longitude)
  end

  def current_location_for(params)
    # A location search was just performed, with the name of the searched location (given back from Nominatim ws) in it.
    return [params[:loc], show_location_popup(params[:loc])] if params.has_key?(:loc)

    # there was no search beforehand, we need to find the address, based on given latitude and longitude.
    current_location = address_from_geocodes(params[:lat], params[:lon])
    current_location = t('home.default_current_loc') if current_location.blank?

    [current_location, show_location_popup(current_location)]
  end

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
    settings = {}
    Setting.all.each do |setting|
      settings[setting['key']]=setting['value']
    end

    # Useful links, for the footer section.
    link_numbers = %w(one two three four five six)
    @links = []
    link_numbers.each do |number|
      @links << get_link(settings["link_#{number}_label"], settings["link_#{number}_label_ka"], settings["link_#{number}_url"])
    end
    settings
  end

end
