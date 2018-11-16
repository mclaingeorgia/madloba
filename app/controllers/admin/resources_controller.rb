class Admin::ResourcesController < AdminController
  before_filter :authenticate_user!
  before_filter { @model = Resource; }

  def index
    authorize @model
    @items = @model.sorted
  end

  def new
    authorize @model
    @item = @model.new

    gon.locales = I18n.available_locales
    gon.resource_item_template = render_to_string 'item_template', layout: false
    gon.labels = {
      new_resource_item: t('admin.resources.new_item')
    }
  end

  def create
    @item = @model.new(strong_params)
    authorize @item

    if @item.save
      flash[:success] = t('app.messages.success_updated', obj: @model)
      redirect_to manage_resources_path
    else
      flash[:error] = format_messages(@item)
      gon.locales = I18n.available_locales
      gon.resource_item_template = render_to_string 'item_template', layout: false
      gon.labels = {
        new_resource_item: t('admin.resources.new_item')
      }
      render action: "new"
    end
  end

  def edit
    @item = @model.find(params[:id])
    authorize @item
    gon.locales = I18n.available_locales
    gon.resource_item_template = render_to_string 'item_template', layout: false
    gon.labels = {
      new_resource_item: t('admin.resources.new_item')
    }
  end

  def update
    @item = @model.find(params[:id])
    authorize @item


    if @item.update_attributes(strong_params)
      flash[:success] = t('app.messages.success_updated', obj: "#{@model.human} #{@item.title}")
      redirect_to manage_resources_path
    else
      flash[:error] = format_messages(@item)
      gon.locales = I18n.available_locales
      gon.resource_item_template = render_to_string 'item_template', layout: false
      gon.labels = {
        new_resource_item: t('admin.resources.new_item')
      }
      render action: "edit"
    end
  end

  def destroy
    item = @model.find(params[:id])
    authorize item

    if item.delete
      flash[:success] =  t("app.messages.success_destroyed", obj: "#{@model.human} #{item.title}")
    else
      flash[:error] =  t('app.messages.fail_destroyed', obj: "#{@model.human} #{item.title}")
      flash[:error] = format_messages(item)
    end

    redirect_to :back
  end

  private

    def strong_params
      params.require(:resource).permit(*@model.globalize_attribute_names, :cover, :order, :remove_cover,
        resource_items_attributes: [:id, :order, :_destroy, *ResourceItem.globalize_attribute_names])
    end
end
