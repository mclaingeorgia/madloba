class Admin::ServicesController < AdminController
  before_filter :authenticate_user!
  before_filter { @model = Service; }
  before_filter :load_new_parent, only: [:new]
  before_filter :load_edit_parent, only: [:edit, :update]

  def index
    authorize @model
    @items = @model.sorted.with_translations(I18n.locale)

    gon.move_up_url = manage_service_move_up_path('[id]')
    gon.move_down_url = manage_service_move_down_path('[id]')
  end

  def new
    authorize @model
    @item = @model.new
  end

  def create
    @item = @model.new(strong_params)
    authorize @item

    if @item.save
      flash[:success] = t('app.messages.success_updated', obj: @model)
      redirect_to manage_services_path
    else
      params[:parent_id] = @item.parent_id
      load_new_parent
      flash[:error] = format_messages(@item)
      render action: "new"
    end
  end

  def edit
    authorize @item
  end

  def update
    authorize @item

    if @item.update_attributes(strong_params)
      flash[:success] = t('app.messages.success_updated', obj: "#{@model.human} #{@item.name}")
      redirect_to manage_services_path
    else
      flash[:error] = format_messages(@item)
      render action: "edit"
    end
  end

  def destroy
    item = @model.find(params[:id])
    authorize item

    if item.destroy
      flash[:success] =  t("app.messages.success_destroyed", obj: "#{@model.human} #{item.name}")
    else
      flash[:error] =  t('app.messages.fail_destroyed', obj: "#{@model.human} #{item.name}")
    end

    redirect_to :back
  end

  def move_up
    item = @model.find(params[:id])
    authorize item

    redirect_path = manage_services_path

    respond_to do |format|
      if item.move_higher
        format.html { redirect_to redirect_path, notice: t('app.messages.success_updated', obj: t('admin.shared.position')) }
        format.json { render json: {flash: {success: t('app.messages.success_updated', obj: t('admin.shared.position')) }} }
      else
        msg = format_messages(item)
        flash[:error] = msg
        format.html { redirect_to redirect_path, error: t('app.messages.fail_updated', obj: t('admin.shared.position')) }
        format.json { render json: {flash: {error: msg} }}
      end
    end
  end

  def move_down
    item = @model.find(params[:id])
    authorize item

    redirect_path = manage_services_path

    respond_to do |format|
      if item.move_lower
        format.html { redirect_to redirect_path, notice: t('app.messages.success_updated', obj: t('admin.shared.position')) }
        format.json { render json: {flash: {success: t('app.messages.success_updated', obj: t('admin.shared.position')) }} }
      else
        msg = format_messages(item)
        flash[:error] = msg
        format.html { redirect_to redirect_path, error: t('app.messages.fail_updated', obj: t('admin.shared.position')) }
        format.json { render json: {flash: {error: msg} }}
      end
    end

  end

  private

    def strong_params
      permitted = @model.globalize_attribute_names + [:for_children, :for_adults, :parent_id ]
      params.require(:service).permit(*permitted)
    end

    def load_new_parent
      @parent = @model.roots.where(id: params[:parent_id]).first if params[:parent_id].present?
      if @parent.nil?
        flash[:error] = t('app.messages.service_parent_missing')
        redirect_to manage_services_path
      end
    end

    def load_edit_parent
      @item = @model.find(params[:id])
      @parent = @item.parent
      # if there is no parent and there is no icon, this is bad
      # - only parents have icons
      if @parent.nil? && @item.icon.nil?
        flash[:error] = t('app.messages.service_parent_missing')
        redirect_to manage_services_path
      end
    end
end
