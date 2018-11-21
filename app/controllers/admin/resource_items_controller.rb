class Admin::ResourceItemsController < AdminController
  before_filter :authenticate_user!
  before_filter { @model = ResourceItem; }

  def index
    authorize @model
    @items = @model.sorted
  end

  def edit
    @item = @model.find(params[:id])
    authorize @item
    gon.locales = I18n.available_locales
    gon.resource_item_template = render_to_string 'item_template', layout: false
    # gon.resource_content_template = render_to_string 'content_template', layout: false
    gon.labels = {
      new_resource_item: t('admin.resources.new_item')
    }
  end

  def update
    @item = @model.find(params[:id])
    authorize @item

    # Rails.logger.debug(strong_params)
    if @item.update_attributes(strong_params)
      flash[:success] = t('app.messages.success_updated', obj: "#{@model.human} #{@item.title}")
      redirect_to manage_resource_items_path
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

  private

    def strong_params
      params.require(:resource_item).permit(*@model.globalize_attribute_names, resource_contents_attributes: [:id, :order, :visual_en, :visual_ka, :_destroy, *ResourceContent.globalize_attribute_names])
    end
end
