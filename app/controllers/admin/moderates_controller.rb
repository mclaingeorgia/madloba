class Admin::ModeratesController < AdminController
  before_filter :authenticate_user!
  # authorize_resource
  # before_filter { @model = PageContent; }

  # rescue_from ActionController::ParameterMissing do |e|
  #   # You can even render a jbuilder template too!
  #   if action_name == "create"
  #     redirect_to new_admin_page_content_path, flash: { error: t('shared.msgs.missing_parameter') }
  #   else
  #      render :nothing => true, :status => 400
  #   end
  # end

  def place_service
    authorize :moderate

    @items = PlaceService.sorted_date.only_active.includes(:place, :service)

  end

  def place_report
    authorize :moderate
    @items = {pending: [], processed: []}.merge(PlaceReport.all.group_by {|b|
      b.processed == 0 ? :pending : :processed
    })

    gon.labels.merge!({
      # state_label: t('shared.labels.state'),
      accept: t('shared.accept'),
      accepted: t('shared.accepted'),
      decline: t('shared.decline'),
      declined: t('shared.declined'),
      moderation_path: manage_update_moderate_place_report_path(id: '_id_', state: 'accept').gsub('accept', '_state_')
    })
  end
  def place_report_update
    authorize :moderate
    pars = strong_params
    item = PlaceReport.find(pars[:id])
    state = ['accept', 'decline'].index(pars[:state])+1

    if item.processed == state
      flash.now[:success] =  t('app.messages.state_already_set', obj: item.place.name)
    elsif item.update_attributes(processed: state, processed_by: current_user.id)
      flash.now[:success] =  t("app.messages.#{stated(pars[:state])}", obj: item.place.name)
      NotificationTrigger.add_moderator_response(:moderator_report_response, item.id)
      forward = { moderate: { type: :report,  id: item.id, state: pars[:state] } }
    else
      flash.now[:error] =  t('app.messages.fail_updated_state', obj: item.place.name)
    end

    forward = {} unless forward.present?
    respond_to do |format|
      format.html { redirect_to manage_moderate_place_report_path }
      format.json { render json: { flash: flash.to_hash }.merge(forward) }
    end
  end

  def place_ownership
    authorize :moderate
    @items = {pending: [], processed: []}.merge(PlaceOwnership.all.group_by {|b|
      b.processed == 0 ? :pending : :processed
    })
    gon.labels.merge!({
      accepted: t('shared.accepted'),
      declined: t('shared.declined')
    })
  end
  def place_ownership_update
    authorize :moderate
    pars = strong_params
    item = PlaceOwnership.find(pars[:id])
    place = Place.find(item.place_id)
    state = ['accept', 'decline'].index(pars[:state])+1

    if !item.is_pending?
      flash.now[:success] =  t('app.messages.state_already_set', obj: place.name)
    elsif item.process(current_user, state)
      flash.now[:success] =  t("app.messages.#{stated(pars[:state])}", obj: place.name)
      NotificationTrigger.add_moderator_response(:moderator_ownership_response, item.id)
      forward = { moderate: { type: :provider,  id: item.id, state: pars[:state] } }
    else
      flash.now[:error] =  t('app.messages.fail_updated_state', obj: place.name)
    end

    forward = {} unless forward.present?
    respond_to do |format|
      format.html { redirect_to manage_moderate_place_ownership_path }
      format.json { render json: { flash: flash.to_hash }.merge(forward) }
    end
  end
  def new_provider
    authorize :moderate
    @items = {pending: [], processed: []}.merge(Provider.not_deleted.only_processed.group_by {|b|
      b.processed == 0 ? :pending : :processed
    })
    gon.labels.merge!({
      accepted: t('shared.accepted'),
      declined: t('shared.declined')
    })
  end

  def new_provider_update
    authorize :moderate
    pars = strong_params
    item = Provider.find(pars[:id])
    state = ['accept', 'decline'].index(pars[:state])+1

    if !item.is_pending?
      flash.now[:success] =  t('app.messages.state_already_set', obj: item.name)
    elsif item.update_attributes(processed: state, processed_by: current_user.id)
      flash.now[:success] =  t("app.messages.#{stated(pars[:state])}", obj: item.name)
      NotificationTrigger.add_moderator_response(:moderator_new_provider_response, item.id)
      forward = { moderate: { type: :provider,  id: item.id, state: pars[:state] } }
    else
      flash.now[:error] =  t('app.messages.fail_updated_state', obj: item.name)
    end

    forward = {} unless forward.present?
    respond_to do |format|
      format.html { redirect_to manage_moderate_new_provider_path }
      format.json { render json: { flash: flash.to_hash }.merge(forward) }
    end
  end


  def place_tag
    authorize :moderate
    @items = {pending: [], processed: []}.merge(Tag.all.group_by {|b|
      b.processed == 0 ? :pending : :processed
    })

    gon.labels.merge!({
      accept: t('shared.accept'),
      accepted: t('shared.accepted'),
      decline: t('shared.decline'),
      declined: t('shared.declined'),
      moderation_path: manage_update_moderate_place_tag_path(id: '_id_', state: 'accept').gsub('accept', '_state_')
    })
  end
  def place_tag_update
    authorize :moderate
    pars = strong_params
    item = Tag.find(pars[:id])
    state = ['accept', 'decline'].index(pars[:state])+1

    if item.processed == state
      flash.now[:success] =  t('app.messages.state_already_set', obj: item.name)
    elsif item.update_attributes(processed: state, processed_by: current_user.id)
      flash.now[:success] =  t("app.messages.#{stated(pars[:state])}", obj: item.name)
      # send notification to user
      forward = { moderate: { type: :tag,  id: item.id, state: pars[:state] } }
    else
      flash.now[:error] =  t('app.messages.fail_updated_state', obj: item.name)
    end

    forward = {} unless forward.present?
    respond_to do |format|
      format.html { redirect_to manage_moderate_place_tag_path }
      format.json { render json: { flash: flash.to_hash }.merge(forward) }
    end
  end

  private
    def strong_params
      params.permit(:id, :state, :locale)
    end

    def stated(state)
      state == 'accept' ? 'accepted' : 'declined'
    end

end
