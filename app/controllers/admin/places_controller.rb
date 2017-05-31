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
    # @item.assets.build(owner_type: 1)
  end

  def create
    pars = strong_params
    redirect_default = pars.delete(:redirect_default) == 'true'
    item = @model.new(pars)
    authorize item

    redirect_path = redirect_default ?
      manage_places_path :
      manage_provider_profile_path(page: 'manage-places')

    @item = item if redirect_default

    if item.save
      flash[:success] = t('app.messages.success_updated', obj: @model)
      redirect_to redirect_path
    else
      flash[:error] = format_messages(item)
      if redirect_default
        render action: "new"
      else
        render 'admin/provider_profile', locals: prepaire_provider_profile(true, :'manage-places', nil, :new, item)
      end
    end
  end

  def edit
    @item = @model.find(params[:id])
    # @item.assets.new(owner_type: 1)
    authorize @item
  end

  def update
    pars = strong_params
    item = @model.find(params[:id])
    authorize item

    tag_ids = pars[:tags].present? ? Tag.process(current_user.id, item.id, pars.delete(:tags)) : []
    pars[:tag_ids] = tag_ids
    old_tag_ids = item.tag_ids - tag_ids

    redirect_default = pars.delete(:redirect_default) == 'true'
    redirect_path = redirect_default ?
      manage_places_path :
      manage_provider_profile_path(page: 'manage-places')

    @item = item if redirect_default

    respond_to do |format|
      if item.update_attributes(pars)
        Tag.remove_pended(old_tag_ids) if old_tag_ids.present?
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
    pars = favorite_params
    forward = set_flash(FavoritePlace.favorite(current_user.id, pars[:id], pars[:flag] == 'true'))
    forward = {} unless forward.present?

    respond_to do |format|
      format.html { redirect_to manage_user_profile_path(page: 'favorite-places') }
      format.json { render json: { flash: flash.to_hash }.merge(forward) }
    end
  end
  def rate
    pars = rate_params
    forward = set_flash(PlaceRate.rate(current_user.id, pars[:id], pars[:rate].to_i))
    forward = {} unless forward.present?

    respond_to do |format|
      format.html { redirect_to manage_user_profile_path(page: 'rated-places') }
      format.json { render json: { flash: flash.to_hash }.merge(forward) }
    end
  end
  def ownership
    pars = ownership_params
  end

  private

    def strong_params
      permitted = @model.globalize_attribute_names + [:website, :postal_code, :region_id, :latitude, :longitude, :poster_id, :published, :redirect_default, emails: [], phones: [], service_ids: [],
        assets_attributes: ["@original_filename", "@content_type", "@headers", "_destroy", "id", "image"], tags: [] ]
      params.require(:place).permit(*permitted)
    end
    def favorite_params
      params.permit(:id, :flag, :locale)
    end
    def rate_params
      params.permit(:id, :rate, :locale)
    end
    def ownership_params
      params.permit(:id, :provider_id, :locale, provider_attributes: [*Provider.globalize_attribute_names])
    end
end
