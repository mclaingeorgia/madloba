class Admin::PageContentsController < AdminController
  before_filter :authenticate_user!
  before_filter { @model = PageContent; }

  def index
    authorize @model
    @items = @model.sorted
  end

  def edit
    @item = @model.find(params[:id])
    authorize @item
    gon.locales = I18n.available_locales
    gon.page_content_item_template = render_to_string 'item_template', layout: false
    gon.labels = {
      new_page_content_item: t('admin.page_contents.new_item')
    }
  end

  def update
    @item = @model.find(params[:id])
    authorize @item


    if @item.update_attributes(strong_params)
      flash[:success] = t('app.messages.success_updated', obj: "#{@model.human} #{@item.title}")
      redirect_to manage_page_contents_path
    else
      flash[:error] = format_messages(@item)
      gon.locales = I18n.available_locales
      gon.page_content_item_template = render_to_string 'item_template', layout: false
      gon.labels = {
        new_page_content_item: t('admin.page_contents.new_item')
      }
      render action: "edit"
    end
  end

  private

    def strong_params
      params.require(:page_content).permit(*@model.globalize_attribute_names, page_content_items_attributes: [:id, :order, "_destroy", *PageContentItem.globalize_attribute_names])
    end
end
