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

  def index
    redirect_to manage_user_profile_path
  end

  def user_profile
    @class = 'user_profile'
    @is_admin_profile_page = false

    page, id, action = get_sub_action(params[:page], params[:id], params[:edit], :user_profile)

    # item = user_profile_prepare_item(page, id, action)
    locals({
      current_page: page,
      action: action#,
      # item: item
    })
  end

  def provider_profile
    @class = 'provider_profile'

    @is_admin_profile_page = false

    page, id, action = get_sub_action(params[:page], params[:id], params[:edit], :provider_profile)

    Rails.logger.debug("-----------------------------------------#{page}---#{id} #{action}")

    providers = Provider.by_user(current_user.id)
    photos = []

    item = provider_profile_prepare_item(page, id, action)
    l = {
      current_page: page,
      action: action,
      item: item,
      providers: providers,
      photos: photos
    }
     Rails.logger.debug("--------------------------------------------#{l}")
    locals({
      current_page: page,
      action: action,
      item: item,
      providers: providers,
      photos: photos
    })
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
      page = page.to_sym

      options.index(page).present? ? page : options[0]
    end

    def get_provider_profile_page (page)
      options = [:'manage-provider', :'manage-places', :'moderate-photos']
      page = page.to_sym

      options.index(page).present? ? page : options[0]
    end
end
