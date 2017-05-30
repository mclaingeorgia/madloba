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
  end

  def update
    @item = @model.find(params[:id])
    authorize @item


    if item.update_attributes(strong_params)
      flash[:success] = t('app.messages.success_updated', obj: "#{@model} #{item.title}")
      redirect_to manage_page_contents_path
    else
      flash[:error] = format_messages(item)
      render action: "edit"
    end
  end

  private

    def strong_params
      permitted = PageContent.globalize_attribute_names + [:name]
      params.require(:page_content).permit(*permitted)
    end
end
