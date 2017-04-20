class Admin::PlacesController < AdminController
  before_filter :authenticate_user!, except: [:show]
  # before_action :authenticate_user!
  # authorize_resource
  before_filter { @model = Place; }

  def index
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
    # @item.destroy

    respond_to do |format|
      format.html do
        redirect_to manage_provider_profile_path(type: 'manage-provider'), flash: {
          success:  t('app.messages.success_destroyed',
                      obj: @model),
          notice: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Enim, officiis?',
                    error: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Soluta, voluptas, ipsa.',
                    alert: 'Lorem ipsum dolor.'
        }
      end
      # format.json { head :no_content }
    end
  end
  # flash message type test
  # def destroy
  #   @item = @model.find(params[:id])
  #   #@item.destroy

  #   respond_to do |format|
  #     format.html do
  #       redirect_to admin_provider_path(tab: 'manage-provider'), flash: {
  #         success:  t('app.messages.success_destroyed',
  #                     obj: t('activerecord.models.provider.one')),
  #         notice: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Enim, officiis?',
  #         error: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Soluta, voluptas, ipsa.',
  #         alert: 'Lorem ipsum dolor.'
  #       }
  #     end
  #     format.json { head :no_content }
  #   end
  # end
  private

  def pars
    params.require(:provider).permit(*Place.globalize_attribute_names)
  end
end
