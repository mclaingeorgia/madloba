class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :set_admin_flag

  def user_profile
    authorize User
    page, id, action = get_sub_action(params[:page], current_user.id, :edit, :user_profile)
    @model = User
    locals(prepaire_user_profile(false, page, id, action, nil))
  end

  def provider_profile
    authorize User
    page, id, action = get_sub_action(params[:page], params[:id], params[:edit], :provider_profile)
    locals(prepaire_provider_profile(false, page, id, action, nil))
  end

  def autocomplete
    type = params[:type]
    related_id = params[:r]
    if type == 'places'
      authorize User, :autocomplete_place?
      results = Place.autocomplete(params[:q], current_user, related_id)
    elsif type == 'users'
      authorize User, :autocomplete_user?
      results = User.autocomplete(params[:q], current_user, related_id)
    elsif type == 'tags'
      authorize User, :autocomplete_tag?
      results = Tag.autocomplete(params[:q])
    end
    render json: { results: results }
  end

  private

    def set_admin_flag
      @is_admin = true # global admin flag
      @is_admin_profile_page = true # default admin_profile page (multiple standalone pages)
      @class = 'admin_profile' # default admin_profile class
    end

    def prepaire_user_profile(false_start, page, id, action, item)
      @is_admin = true
      @is_admin_profile_page = true
      @class << ' user_profile'
      @has_slideshow = true

      unless false_start
        item = provider_profile_prepare_item_by_model(User, action, id)
      end

      item.providers.build if !item.is_service_provider? # create new provider to use it in form if not service provider yet

      gon.labels.merge!({
        favorite: t('shared.favorite'),
        unfavorite: t('shared.unfavorite')
      })

      {
        current_page: page,
        action: action,
        item: item,
        favorite_places: current_user.favorites,
        rated_places: current_user.rates,
        invitations: PlaceInvitation.pending.by_email(current_user.email)
      }
    end
    def prepaire_provider_profile(false_start, page, id, action, item)
      @is_admin = true
      @is_admin_profile_page = true
      @class << ' provider_profile'
      @has_slideshow = true

      places = Place.only_active.for_user(current_user)

      unless false_start
        item = provider_profile_prepare_item(page, id, action)
      end

      @model = item.class

      gon.labels.merge!({
        # state_label: t('shared.labels.state'),
        accept: t('shared.accept'),
        accepted: t('shared.accepted'),
        decline: t('shared.decline'),
        declined: t('shared.declined')
      })

      {
        current_page: page,
        action: action,
        item: item,
        places: places
      }
    end

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
      if page == :'manage-providers'
        provider_profile_prepare_item_by_model(Provider, action, id)
      elsif page == :'manage-places'
        provider_profile_prepare_item_by_model(Place, action, id)
      elsif page == :'moderate-photos'
        provider_profile_prepare_item_by_model(Place, action, id)
      end
    end

    def provider_profile_prepare_item_by_model(model, action, id)
      if action == :index
        nil
      elsif action == :new
        model.new
      elsif action == :edit
        model.find(id)
      end
    end

    def get_user_profile_page(page)
      options = [:'manage-profile', :'favorite-places', :'rated-places', :'uploaded-photos', :'pending-invitations']
      page = options[0] if page.nil?
      page = page.to_sym

      options.index(page).present? ? page : options[0]
    end

    def get_provider_profile_page (page)
      options = [:'manage-providers', :'manage-places', :'moderate-photos']
      page = options[1] if page.nil?
      page = page.to_sym

      options.index(page).present? ? page : options[1]
    end
end
