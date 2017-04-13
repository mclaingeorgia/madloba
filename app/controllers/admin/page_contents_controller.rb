class Admin::PageContentsController < AdminController
  before_filter :authenticate_user!
  # authorize_resource
  before_filter { @model = PageContent; }

  # rescue_from ActionController::ParameterMissing do |e|
  #   # You can even render a jbuilder template too!
  #   if action_name == "create"
  #     redirect_to new_admin_page_content_path, flash: { error: t('shared.msgs.missing_parameter') }
  #   else
  #      render :nothing => true, :status => 400
  #   end
  # end

  def index
    @items = @model.sorted

    respond_to do |format|
      format.html
    end
  end

  def show
    @item = @model.find(params[:id])

    respond_to do |format|
      format.html
      # format.json { render json: @item }
    end
  end

  def edit
    @item = @model.find(params[:id])
  end

  def update
     Rails.logger.debug("--------------------------------------------#{pars}")
    @item = @model.find(params[:id])
    respond_to do |format|
      if @item.update_attributes(pars)
        format.html do
          redirect_to manage_provider_profile_path(type: 'manage-provider'), flash: {
            success:  t('app.messages.success_updated',
                        obj: @model)
          }
        end
      else
        format.html do
          redirect_to manage_provider_profile_path(type: 'manage-provider', id: @item.id), flash: {
            error:  t('app.messages.fail_updated',
                        obj: @model)
          }
        end
      end
    end
  end

  def destroy
    @item = @model.find(params[:id])
    @item.destroy

    respond_to do |format|
      format.html do
        redirect_to admin_provider_path(tab: 'manage-provider'), flash: {
          success:  t('app.messages.success_destroyed',
                      obj: @model)
        }
      end
      # format.json { head :no_content }
    end
  end
  private
    def pars
      permitted = Product.globalize_attribute_names + [:name]
      params.require(:page_content).permit(*permitted)
    end
end
