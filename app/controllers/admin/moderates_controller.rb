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
  def place_report
    @items = {pending: [], processed: []}.merge(PlaceReport.all.group_by {|b|
      b.processed == 0 ? :pending : :processed
    })

    gon.labels.merge!({
      state_label: t('shared.labels.state'),
      accept: t('shared.accept'),
      accepted: t('shared.accepted'),
      decline: t('shared.decline'),
      declined: t('shared.declined'),
      place_report_path: manage_update_moderate_place_report_path(id: '_id_', state: 'accept').gsub('accept', '_state_')
    })
  end
  def place_report_update
    pars = place_report_params
    item = PlaceReport.find(pars[:id])
    state = ['accept', 'decline'].index(pars[:state])+1

    if item.processed == state
      flash.now[:success] =  t('app.messages.state_already_set', obj: item.place.name)
    elsif item.update_attributes(processed: state, processed_by: current_user.id)
      flash.now[:success] =  t("app.messages.#{pars[:state]}d", obj: item.place.name)
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
    @items = {pending: [], processed: []}.merge(PlaceOwnership.all.group_by {|b|
      b.processed == 0 ? :pending : :processed
    })


  end
  def place_ownership_update
    # pars = reported_places_params
    # item = PlaceReport.find(pars[:id])
    # state = ['accept', 'decline'].index(pars[:state])+1

    # if item.processed == state
    #   flash.now[:success] =  t('app.messages.state_already_set', obj: item.place.name)
    # elsif item.update_attributes(processed: state, processed_by: current_user.id)
    #   flash.now[:success] =  t("app.messages.#{pars[:state]}d", obj: item.place.name)
    #   forward = { moderate: { type: :report,  id: item.id, state: pars[:state] } }
    # else
    #   flash.now[:error] =  t('app.messages.fail_updated_state', obj: item.place.name)
    # end

    # forward = {} unless forward.present?
    # respond_to do |format|
    #   format.html { redirect_to manage_moderate_reported_places_path }
    #   format.json { render json: { flash: flash.to_hash }.merge(forward) }
    # end
  end
  def new_provider
  end
  def place_tag
    @items = {pending: [], processed: []}.merge(Tag.all.group_by {|b|
      b.processed == 0 ? :pending : :processed
    })

    # gon.labels.merge!({
    #   state_label: t('shared.labels.state'),
    #   accept: t('shared.accept'),
    #   accepted: t('shared.accepted'),
    #   decline: t('shared.decline'),
    #   declined: t('shared.declined'),
    #   reported_places_path: manage_update_moderate_reported_places_path(id: '_id_', state: 'accept').gsub('accept', '_state_')
    # })
  end
  def place_tag_update

  end

  private

    def place_report_params
      params.permit(:id, :state, :locale)
    end
  # def index
  #   @items = @model.sorted

  #   respond_to do |format|
  #     format.html
  #   end
  # end

  # def show
  #   @item = @model.find(params[:id])

  #   respond_to do |format|
  #     format.html
  #     # format.json { render json: @item }
  #   end
  # end

  # def new
  #   @item = @model.new

  #   respond_to do |format|
  #     format.html
  #   end
  # end

  # def create
  #   @item = @model.new(pars)

  #   respond_to do |format|
  #     if @item.save
  #       format.html do
  #         redirect_to manage_page_contents_path, flash: {
  #           success:  t('app.messages.success_updated', obj: @model) }
  #       end
  #     else
  #       format.html { render action: "new" }
  #     end
  #   end
  # end

  # def edit
  #   @item = @model.find(params[:id])
  # end

  # def update
  #   @item = @model.find(params[:id])
  #   respond_to do |format|
  #     if @item.update_attributes(pars)
  #       format.html do
  #         redirect_to manage_page_contents_path, flash: {
  #           success:  t('app.messages.success_updated',
  #                       obj: @model)
  #         }
  #       end
  #     else
  #       format.html do
  #         redirect_to manage_page_content_path(id: @item.id), flash: {
  #           error:  t('app.messages.fail_updated',
  #                       obj: @model)
  #         }
  #       end
  #     end
  #   end
  # end

  # def destroy
  #   @item = @model.find(params[:id])
  #   @item.destroy

  #   respond_to do |format|
  #     format.html do
  #       redirect_to manage_page_contents_path, flash: {
  #         success:  t('app.messages.success_destroyed',
  #                     obj: @model)
  #       }
  #     end
  #     # format.json { head :no_content }
  #   end
  # end
  # private
  #   def pars
  #     permitted = PageContent.globalize_attribute_names + [:name]
  #     params.require(:page_content).permit(*permitted)
  #   end
end
