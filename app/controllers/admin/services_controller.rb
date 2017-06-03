class Admin::ServicesController < AdminController
  before_filter :authenticate_user!
  before_filter { @model = Service; }

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


    if @item.update_attributes(strong_params)
      flash[:success] = t('app.messages.success_updated', obj: "#{@model.human} #{@item.name}")
      redirect_to manage_services_path
    else
      flash[:error] = format_messages(@item)
      render action: "edit"
    end
  end

  private

    def strong_params
      params.require(:service).permit(*@model.globalize_attribute_names)
    end
end