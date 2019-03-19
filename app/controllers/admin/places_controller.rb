class Admin::PlacesController < AdminController
  before_filter :authenticate_user!
  before_filter { @model = Place; }

  def index
    authorize @model
    @items = @model.sorted
  end

  def new
    authorize @model
    @item = @model.new
    gon.autocomplete = { tags: manage_autocomplete_path(:tags) }
    gon.tag_states = {
      pending: t('shared.pending'),
      accepted: t('shared.accepted')
    }
    # @item.assets.build(owner_type: 1)
  end

  def create
    pars = strong_params

    tags = pars[:tags].present? ? pars.delete(:tags) : []

    # if pars[:provider_id].present?
    #   provider = Provider.find_by(id: pars[:provider_id])
    # end

    redirect_default = pars.delete(:redirect_default) == 'true'
    # redirect_path = redirect_default ?
    #   manage_places_path :
    #   manage_provider_profile_path(page: 'manage-places')
    redirect_path = manage_places_path

    item = @model.new(pars)
    authorize item

    @item = item if redirect_default

    if item.save
      tag_ids = tags.present? ? Tag.process(current_user.id, item.id, tags) : []
      item.update_attributes({ tag_ids: tag_ids })

      # if provider.present?
      #   provider.places << item
      # end

      flash[:success] = t('app.messages.success_updated', obj: @model)
      redirect_to redirect_path
    else
      flash[:error] = format_messages(item)
      # if redirect_default
        render action: "new"
      # else
      #   render 'admin/provider_profile', locals: prepaire_provider_profile(true, :'manage-places', nil, :new, item)
      # end
    end
  end

  def edit
    @item = @model.find(params[:id])
    # @item.assets.new(owner_type: 1)
    authorize @item
    gon.autocomplete = { tags: manage_autocomplete_path(:tags) }
    gon.tag_states = {
      pending: t('shared.pending'),
      accepted: t('shared.accepted')
    }
  end

  def update
    pars = strong_params
    item = @model.find(params[:id])
    authorize item
    tag_ids = (pars[:tags].present? ? Tag.process(current_user.id, item.id, pars.delete(:tags)) : []) + item.tags.declined.pluck(:id)
    pars[:tag_ids] = tag_ids
    old_tag_ids = item.tags.active.pluck(:id) - tag_ids

    # if pars[:provider_id].present?
    #   provider = Provider.find_by(id: pars[:provider_id])
    # end


    redirect_default = pars.delete(:redirect_default) == 'true'
    # redirect_path = redirect_default ?
    #   manage_places_path :
    #   manage_provider_profile_path(page: 'manage-places')
    redirect_path = manage_places_path

    @item = item if redirect_default
    respond_to do |format|
      if item.update_attributes(pars)
        Tag.remove_pended(old_tag_ids) if old_tag_ids.present?

        # if provider.present?
        #   item.provider.places.delete(item) if item.provider.present?
        #   provider.places << item
        # end

        flash[:success] = t('app.messages.success_updated', obj: "#{@model.human} #{item.name}")
        format.html { redirect_to redirect_path }
        format.json { render json: { flash: flash.to_hash, remove_asset: pars[:assets_attributes][:id] } }
      else
        flash[:error] = format_messages(item)
        if redirect_default
          format.html { render action: "edit" }
          format.json { render json: { flash: flash.to_hash } }
        else
          format.html { render 'admin/provider_profile', locals: prepaire_provider_profile(true, :'manage-places', nil, :edit, item) }
          format.json { render json: { flash: flash.to_hash } }
        end
      end
    end
  end

  def destroy_asset
    pars = destroy_asset_strong_params
    item = @model.find(params[:id])
    authorize item
    asset_attrs = pars[:assets_attributes]

    respond_to do |format|
      if asset_attrs[:_destroy] == 'true' && asset_attrs[:id].present? && item.destroy_asset(asset_attrs[:id])
        flash[:success] = t('app.messages.success_updated', obj: "#{@model.human} #{item.name}")
        format.json { render json: { flash: flash.to_hash, remove_asset: pars[:assets_attributes][:id] } }
      else
        flash[:error] = format_messages(item)
        format.json { render json: { flash: flash.to_hash } }
      end
    end
  end

  def destroy
    item = @model.find(params[:id])
    authorize item

    if item.update_attributes(deleted: 1)
      flash[:success] =  t("app.messages.success_destroyed", obj: "#{@model.human} #{item.name}")
    else
      flash[:error] =  t('app.messages.fail_destroyed', obj: "#{@model.human} #{item.name}")
      flash[:error] = format_messages(item)
    end

    redirect_to :back
  end

  def restore
    item = @model.find(params[:id])
    authorize item

    if item.update_attributes(deleted: 0)
      flash[:success] =  t("app.messages.success_restored", obj: "#{@model.human} #{item.name}")
    else
      flash[:error] =  t('app.messages.fail_restored', obj: "#{@model.human} #{item.name}")
    end

    redirect_to :back
  end

  def favorite
    authorize Place
    pars = favorite_params
    forward = set_flash(FavoritePlace.favorite(current_user.id, pars[:id], pars[:flag] == 'true'))
    forward = {} unless forward.present?

    respond_to do |format|
      format.html { redirect_to manage_user_profile_path(page: 'favorite-places') }
      format.json { render json: { flash: flash.to_hash }.merge(forward) }
    end
  end
  def rate
    authorize Place
    pars = rate_params
    forward = set_flash(PlaceRate.rate(current_user.id, pars[:id], pars[:rate].to_i))
    forward = {} unless forward.present?

    respond_to do |format|
      format.html { redirect_to manage_user_profile_path(page: 'rated-places') }
      format.json { render json: { flash: flash.to_hash }.merge(forward) }
    end
  end
  def ownership
    authorize Place
    pars = ownership_params
    forward = set_flash(PlaceOwnership.request_ownership(current_user, pars[:id]), false)
    forward = {} unless forward.present?
    redirect_to :back
  end

  def select_service

    @item = @model.find(params[:id])
    authorize @item

    @services = Service.sorted.with_translations(I18n.locale)

    if request.patch?
      # see if services have been selected
      if (params[:root_service].present? && params[:services].present?)
        # save the selected services
        params[:services].each do |service_id|
          service = @services.select{|x| x.id.to_s == service_id}.first
          if service.present?
            # if already exists, do nothing
            if @item.place_services.select{|x| x.service_id == service.id}.empty?
              @item.place_services.create(service_id: service.id)
            end
          else
#TODO
          end
        end

        # go to the input form
        flash[:success] =  t('app.messages.success_created', obj: PlaceService.model_name.human)
        redirect_to manage_place_input_service_path(@item, params[:services].first)
      else
        flash[:error] =  t('app.messages.missing_services')
      end
    end
  end

  def input_service
    @place = @model.find(params[:place_id])
    authorize @place

    @item = @place.place_services.where(service_id: params[:id]).first

    @services = Service.sorted.with_translations(I18n.locale)

    gon.municipality_placeholder = I18n.t('admin.shared.select_all')

    if request.patch?


    end
  end

  def destroy_service
    @item = @model.find(params[:place_id])
    authorize @item

    if @item.place_services.where(service_id: params[:id]).destroy_all
      flash[:success] =  t("app.messages.success_destroyed", obj: "#{PlaceService.model_name.human} #{@item.name}")
    else
      flash[:error] =  t('app.messages.fail_destroyed', obj: "#{PlaceService.model_name.human} #{@item.name}")
      flash[:error] = format_messages(item)
    end
    redirect_to manage_places_path
  end


  private

    def strong_params
      # permitted = @model.globalize_attribute_names + [:postal_code, :region_id, :latitude, :longitude, :poster_id, :published, :redirect_default, :provider_id, emails: [], websites: [], phones: [], service_ids: [],
      permitted = @model.globalize_attribute_names + [:postal_code, :region_id, :municipality_id, :latitude, :longitude, :poster_id, :published, :redirect_default, :email, :website, :facebook, :phone, :phone2, service_ids: [],
        assets_attributes: ["@original_filename", "@content_type", "@headers", "_destroy", "id", "image"], tags: [] ]
      params.require(:place).permit(*permitted)
    end
    def destroy_asset_strong_params
      params.require(:place).permit([ assets_attributes: ["_destroy", "id"]] )
    end
    def favorite_params
      params.permit(:id, :flag, :locale)
    end
    def rate_params
      params.permit(:id, :rate, :locale)
    end
    def ownership_params
      # params.permit(:id, :locale, :authenticity_token, :provider_id, provider_attributes: [*Provider.globalize_attribute_names])
      params.permit(:id, :locale, :authenticity_token)
    end
end
