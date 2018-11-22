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

    params = strong_params
    if params.has_key?(:resource_contents_attributes)
      resource_contents_attributes = params[:resource_contents_attributes].values()
      params = params.except(:resource_contents_attributes)
      new_resource_contents = []
      resource_contents_attributes.each {|item_params|
        if item_params.has_key?('id')
          item = ResourceContent.find(item_params['id'])
          if item_params.has_key?('_destroy') && item_params['_destroy'] == "1"
            item.destroy()
          else
            item.update_attributes(item_params.except('id'))
          end
        else
          new_resource_contents << item_params
        end
      }
      if new_resource_contents.present?
        r_attrs = {}
        new_resource_contents.each_with_index{|m, m_i|
          r_attrs[m_i.to_s] = m
        }
        params[:resource_contents_attributes] = r_attrs
      end
    end

    if @item.update_attributes(params)
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
