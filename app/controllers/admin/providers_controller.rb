class Admin::ProvidersController < AdminController
  before_filter :authenticate_user!, except: [:show, :send_message]
  # before_action :authenticate_user!
  # authorize_resource
  before_filter { @model = Provider; }

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
          redirect_to manage_provider_profile_path(page: 'manage-provider'), flash: {
            success:  t('app.messages.success_updated',
                        obj: @model)
          }
        end
      else
        format.html do
          redirect_to manage_provider_profile_path(page: 'manage-provider', id: @item.id), flash: {
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
        redirect_to manage_provider_profile_path(page: 'manage-provider'), flash: {
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

  def send_message
    # @user = User.new(params[:user].permit(:name))
    # if verify_recaptcha(model: @user) && @user.save
    #   redirect_to @user
    # else
    #   render 'new'
    # end
    pars = params.permit(:authenticity_token, :locale, :'g-recaptcha-response', {:message => [:sender, :email, :text]})
    message = pars[:message]
    verification = verify_message(message)

    # flash = { message: 'test message' }
    respond_to do |format|
      format.html do
          redirect_to :back
      end
    end
  end

  def verify_message(message)
    errors = []
    if verify_recaptcha
      errors << { type: :error, text: t('.sender_missing') } if message[:sender].nil?
      errors << { type: :error, text: t('.improper_email_') } if /\A[^@]+@[^@]+\z/.match(message[:email]).present?
      errors << { type: :error, text: t('.text_missing') } if message[:text].nil?
    else
      errors << { type: :error, text: t('.skynet_detected') } if message[:sender].nil?
    end

    errors.present? ? errors : true

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
    params.require(:provider).permit(*Provider.globalize_attribute_names)
  end
end
