class Admin::ServicesController < AdminController
  before_filter :authenticate_user!
  before_filter { @model = Service; }
  before_filter :load_new_parent, only: [:new]
  before_filter :load_edit_parent, only: [:edit, :update]

  def index
    authorize @model
    @items = @model.sorted.with_translations(I18n.locale)
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
