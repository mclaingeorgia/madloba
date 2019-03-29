class Admin::PlacesController < AdminController
  before_filter :authenticate_user!
  before_filter { @model = Place; }

  def index
    authorize @model
    @items = @model.sorted.with_translations(I18n.locale).include_services
    if current_user.provider?
      # only get places the user is assigned to and not deleted
      @items = @items.for_user(current_user).only_active
    end
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
    redirect_path = redirect_default ?
      manage_places_path :
      manage_provider_profile_path(page: 'manage-places')
    # redirect_path = manage_places_path

    item = @model.new(pars)
    authorize item

    @item = item if redirect_default

    if item.save
      # if the user is not an admin then assign them to the place
      if !current_user.admin?
        item.users << current_user
      end

      tag_ids = tags.present? ? Tag.process(current_user.id, item.id, tags) : []
      item.update_attributes({ tag_ids: tag_ids })

      # if provider.present?
      #   provider.places << item
      # end

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
    redirect_path = redirect_default ?
      manage_places_path :
      manage_provider_profile_path(page: 'manage-places')
    # redirect_path = manage_places_path

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

    pars = select_service_params
    @services = Service.sorted.with_translations(I18n.locale)

    if request.patch?
      # see if services have been selected
      if (pars[:root_service].present? && pars[:services].present?)
        errors = false
        service_ids = []
        # save the selected services
        pars[:services].each do |service_id|
          service = @services.select{|x| x.id.to_s == service_id}.first
          if service.present?
            # if already exists, do nothing
            # unless it is deleted then un-deleted it
            # else if not exist, lets create it
            existing_item = @item.place_services.select{|x| x.service_id == service.id}.first
            if existing_item.present?
              if existing_item.deleted == 1
                existing_item.deleted = 0
                existing_item.save
                service_ids << existing_item.id
              end
            else
              service = @item.place_services.new(service_id: service.id)
              if service.save(:validate => false)
                service_ids << service.id
              else
                errors = true
              end
            end
          else
#TODO
          end
        end

        if !errors
          # go to the input form
          flash[:success] =  t('app.messages.success_created', obj: PlaceService.model_name.human)
          redirect_to manage_place_input_service_path(@item, service_ids.first, ids: service_ids)
        else
          flash[:error] =  t('app.messages.missing_services')
        end
      else
        flash[:error] =  t('app.messages.missing_services')
      end
    end
  end

  def input_service
    redirect_path = manage_places_path

    @place = @model.find(params[:place_id])
    authorize @place

    @item = @place.place_services.only_active.where(id: params[:id]).first

    if @item.nil?
      flash[:error] =  t('app.messages.record_not_found', obj: PlaceService.model_name.human)
      redirect_to redirect_path
    end

    @services = Service.sorted.with_translations(I18n.locale)

    gon.municipality_placeholder = I18n.t('admin.shared.select_all')
    gon.confirm_leave_form = I18n.t('app.messages.confirm_leave_form')

    pars = input_service_params

    if request.patch?
      respond_to do |format|
        if @item.update_attributes(pars[:place_service])
          format.html { redirect_to redirect_path, notice: t('app.messages.success_updated', obj: "#{PlaceService.model_name.human} #{@item.service.name}") }
          format.json { render json: {item: @item, flash: {success: t('app.messages.success_updated', obj: "#{PlaceService.model_name.human} #{@item.service.name}")}} }
        else
          msg = format_messages(@item)
          flash[:error] = msg
          format.html {  }
          format.json { render json: {errors: @item.errors, flash: {error: msg} }}
        end
      end

    end
  end

  def destroy_service
    place = @model.find(params[:place_id])
    item = place.place_services.where(id: params[:id]).first
    authorize place

    if item.update_attributes(deleted: 1)
      flash[:success] =  t("app.messages.success_destroyed", obj: "#{PlaceService.model_name.human} #{item.service.name}")
    else
      flash[:error] =  t('app.messages.fail_destroyed', obj: "#{PlaceService.model_name.human} #{item.service.name}")
      flash[:error] = format_messages(item)
    end
    redirect_to manage_places_path
  end

  def invitations

    @item = @model.find(params[:id])
    authorize @item

    if request.patch?
      pars = invitation_email_params
      emails = pars[:emails].split(',').map{|x| x.strip.chomp}
      if emails.length >  0
        emails.each do |email|
          inv = @item.place_invitations.create(email: email, sent_by: current_user)
          message = Message.new
          message.to = email
          message.subject = I18n.t('notification.place_invitation.subject', place: @item.name)
          message.token = inv.token
          ApplicationMailer.send_place_invitations(@item, message).deliver_now
        end
        flash[:success] =  t("app.messages.success_sent", obj: PlaceInvitation.model_name.human)
      end
    end
  end

  def accept_invitation

    item = PlaceInvitation.pending.by_token(params[:token]).first

    authorize @model

    if item.present?
      item.has_accepted = true
      item.user = current_user
      item.save
      flash[:success] =  t("app.messages.success_accepted", obj: PlaceInvitation.model_name.human)
    else
      flash[:error] =  t("app.messages.record_not_found", obj: PlaceInvitation.model_name.human)
    end

    redirect_to manage_places_path
  end

  def destroy_invitation

    place = @model.find(params[:place_id])
    item = place.place_invitations.where(id: params[:id]).first
    authorize place

    if item.destroy
      flash[:success] =  t("app.messages.success_destroyed", obj: "#{PlaceInvitation.model_name.human} #{item.email}")
    else
      flash[:error] =  t('app.messages.fail_destroyed', obj: "#{PlaceInvitation.model_name.human} #{item.email}")
      flash[:error] = format_messages(item)
    end
    redirect_to manage_place_invitations_path(place)
  end

  def destroy_user

    place = @model.find(params[:place_id])
    item = place.place_users.where(id: params[:id]).first
    authorize place

    if item.destroy
      flash[:success] =  t("app.messages.success_removed", obj: "#{User.model_name.human} #{item.user.name}")
    else
      flash[:error] =  t('app.messages.fail_removed', obj: "#{User.model_name.human} #{item.user.name}")
      flash[:error] = format_messages(item)
    end
    redirect_to manage_place_invitations_path(place)
  end

  private

    def strong_params
      # permitted = @model.globalize_attribute_names + [:postal_code, :region_id, :latitude, :longitude, :poster_id, :published, :redirect_default, :provider_id, emails: [], websites: [], phones: [], service_ids: [],
      permitted = @model.globalize_attribute_names + [:name, :director, :city, :address, :postal_code, :region_id, :municipality_id, :latitude, :longitude, :poster_id, :published, :redirect_default, :email, :website, :facebook, :phone, :phone2, service_ids: [],
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
    def select_service_params
      params.permit(:id, :locale, :authenticity_token, :root_service, services: [])
    end
    def input_service_params
      params.permit(:place_id, :id, :locale, :authenticity_token, place_service: [
        :is_restricited_geographic_area,
        :act_regulating_service, :act_link, :description,
        :has_age_restriction, :can_be_used_by, :need_finance, :get_involved_link,
        :published,
        geographic_area_municipalities: [],
        service_type: [],
        age_groups: [],
        diagnoses: [],
        service_activities: [],
        service_specialists: []
       ])
    end
    def invitation_email_params
      params.permit(:id, :emails)
    end
end
