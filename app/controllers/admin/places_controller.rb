class Admin::PlacesController < AdminController
  before_filter :authenticate_user!, except: [:show, :favoritize]
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

  def new
    @item = @model.new

    respond_to do |format|
      format.html
    end
  end

  def create
    @item = @model.new(pars)

    respond_to do |format|
      if @item.save
        format.html do
          redirect_to manage_place_path, flash: {
            success:  t('app.messages.success_updated', obj: @model) }
        end
      else
        format.html { render action: "new" }
      end
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
          redirect_to manage_provider_profile_path(page: 'manage-places'), flash: {
            success:  t('app.messages.success_updated',
                        obj: @model)
          }
        end
      else
        format.html do
          redirect_to manage_provider_profile_path(page: 'manage-places', id: @item.id), flash: {
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
        redirect_to manage_provider_profile_path(page: 'manage-places'), flash: {
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
  def favoritize
    params = favoritize_params
    if request.xhr?
      if user_signed_in?
        render html: 'Action allowed'
      else
        #session[:post_action] = 'favoritize' #{ type: 'favoritize', id: params[:place_id] }
        store_location_for(:user, place_favoritize_path)#(id: params[:place_id]))
        render json: { trigger: 'sign_in', flash: { notice: t('devise.failure.unauthenticated') } }, status: :unauthorized
      end
    else
      if user_signed_in?
        place_favoritize(params[:place_id])
        flash[:success] = 'Place was favoritized'
      else
        flash[:error] = 'Unathorized'
      end

      redirect_to place_path(id: params[:place_id])
    end
  end
  # flash message type test
  # def destroy
  #   @item = @model.find(params[:id])
  #   #@item.destroy

  #   respond_to do |format|
  #     format.html do
  #       redirect_to admin_provider_path(tab: 'manage-places'), flash: {
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
    permitted = Place.globalize_attribute_names + [:phone, :website, :postal_code, :region_id, :latitude, :longitude, service_ids: []]
    params.require(:place).permit(*permitted)
  end
  def favoritize_params
    params.permit(:place_id, :locale)
  end
end
