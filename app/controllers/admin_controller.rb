class AdminController < ApplicationController

  before_action :authenticate_user!
  before_action :set_admin_flag

  # before_filter :requires_user

  # include ApplicationHelper

  # # Style used to display messages on 'Area settings' page
  # STYLES = {success: 'text-success', error: 'text-danger' }

  # def requires_user
  #   if !user_signed_in?
  #     redirect_to '/user/login'
  #   end
  # end

  # def index
  #   @messages = []
  #   if (current_user.super_admin?)
  #     # To-do list creation
  #     Todo.all.each do |todo|
  #       @messages << todo.message_and_alert if !todo.condition_met?
  #     end
  #   end
  # end

  def set_admin_flag
    @is_admin = true
    @is_admin_profile_page = true
    @class = 'admin_profile'
    #gon.default_point = [41.74288345375358, 44.74130630493165]
  end

  # def index
  #   redirect_to manage_user_profile_path
  # end

  def user_profile
    @class = 'user_profile'
    @has_slideshow = true
    @is_admin_profile_page = false

    page, id, action = get_sub_action(params[:page], params[:id], params[:edit], :user_profile)

    gon.labels.merge!({
      favorite: t('shared.favorite'),
      unfavorite: t('shared.unfavorite')
    })
    # favorite_places = current_user.favorites
    # rated_places = current_user.rates
    # item = user_profile_prepare_item(page, id, action)
    locals({
      current_page: page,
      action: action,
      favorite_places: current_user.favorites,
      rated_places: current_user.rates,
      uploads_by_place: current_user.uploads.group_by(&:place_id)
      # item: item
    })
  end

  def provider_profile
    @class = 'provider_profile'
    @has_slideshow = true
    @is_admin_profile_page = false

    page, id, action = get_sub_action(params[:page], params[:id], params[:edit], :provider_profile)

    Rails.logger.debug("-----------------------------------------#{page}---#{id} #{action}")

    providers = Provider.active.by_user(current_user.id)
    photos = []

    item = provider_profile_prepare_item(page, id, action)

    uploads_by_place = []
    providers.sorted.each do |provider|
      provider.places.sorted.each do |place|
        uploads = place.uploads.sorted
        uploads_by_place << [place.id, uploads] if uploads.present?
      end
    end

    gon.labels.merge!({
      state_label: t('shared.labels.state'),
      accept: t('shared.accept'),
      accepted: t('shared.accepted'),
      decline: t('shared.decline'),
      declined: t('shared.declined'),
      upload_state_path: manage_update_moderate_upload_state_path(id: '_id_', state: 'accept').gsub('accept', '_state_')
    })

    l = {
      providers: providers,
      current_page: page,
      action: action,
      item: item,
      uploads_by_place: uploads_by_place
    }
     Rails.logger.debug("--------------------------------------------#{l}")
    locals(l)
  end




  private


    def locals(values)
      render locals: values
    end

    def get_sub_action (page, id, edit, action)
      sub_action = :index
      if id.present?
        if id == 'new'
          id = nil
          sub_action = :new
        elsif edit.present?
          sub_action = :edit
        end
      end

      if action == :user_profile
        page = get_user_profile_page(page)
      elsif action == :provider_profile
        page = get_provider_profile_page(page)
      end

      [page, id, sub_action]
    end

    def provider_profile_prepare_item(page, id, action)
       Rails.logger.debug("--------------------------------------------#{page}, #{id} #{action}")

      if page == :'manage-provider'
        provider_profile_prepare_item_by_model(Provider, action, id)
      elsif page == :'manage-places'
        provider_profile_prepare_item_by_model(Place, action, id)
      elsif page == :'moderate-photos'
        provider_profile_prepare_item_by_model(Place, action, id)
      end

      # @edit_states = [false, false, false]
      # if @id.present?
      #   if @type == 'manage-provider'

      #   elsif @type == 'manage-places'
      #     @edit_states[1] = true
      #     @item = Place.find(@id)
      #   end
      #   @edit_states[2] = true if @type == 'moderate-photos'
      # end

    end

    def provider_profile_prepare_item_by_model(model, action, id)
      if action == :index
        nil
      elsif action == :new
        model.new
      elsif action == :edit
         Rails.logger.debug("--------------------------------------------#{id}")
        model.find(id)
      end
    end

    def get_user_profile_page(page)
      options = [:'manage-profile', :'favorite-places', :'rated-places', :'uploaded-photos']
      page = options[0] if page.nil?
      page = page.to_sym

      options.index(page).present? ? page : options[0]
    end

    def get_provider_profile_page (page)
      options = [:'manage-provider', :'manage-places', :'moderate-photos']
      page = page.to_sym

      options.index(page).present? ? page : options[0]
    end
end
