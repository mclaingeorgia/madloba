class Users::SessionsController < Devise::SessionsController
  respond_to :js, :html, :json
  def new
    @post_url = params[:post]
    super
  end

  def create
     Rails.logger.debug("--------------------------------------------1#{params.inspect}")
    self.resource = warden.authenticate!(auth_options)
     Rails.logger.debug("--------------------------------------------2")
    # resource = User.find_for_database_authentication(email: params[:user][:email])
    return invalid_login_attempt unless resource

    if resource.valid_password?(params[:user][:password])
      sign_in(resource_name, resource)
      # Rails.logger.debug("--------------------------------------------4#{after_sign_in_path_for(resource)}")
      # Rails.logger.debug("--------------------------------------------5")

      #return render nothing: true
    # else
      # invalid_login_attempt
    end
      respond_with resource, location: after_sign_in_path_for(resource)
 end

  def destroy
    super
  end

  # protected

  def invalid_login_attempt
    set_flash_message(:alert, :invalid)
    render json: flash[:alert], status: 401
  end
end


   # def create
   #  #self.resource = warden.authenticate!(auth_options)
   #  self.resource = warden.authenticate!(:scope => resource_name)#, :recall => 'users/sessions#failure')
   #  set_flash_message(:notice, :signed_in) if is_flashing_format?
   #  sign_in(resource_name, resource)
   #  yield resource if block_given?
   #      if resource.valid?
   #          respond_with resource, location: root_path #after_sign_in_path_for(resource)
   #      else
   #          respond_to do |format|
   #          format.html { redirect_to after_sign_in_path_for(resource) }
   #          format.json { render :json => {url: after_sign_in_path_for(resource)} }
   #      end
   #  end
   #  #respond_with resource, location: after_sign_in_path_for(resource)
   # end
   #   def failure
   #       Rails.logger.debug("--------------------------------------------#{self.errors.inspect}")
   #      render :json => { :errors => self.flash.to_hash, sessions: true }, :status => :error
   #  end

    # self.resource = warden.authenticate!(auth_options)
    # set_flash_message!(:notice, :signed_in)
    # sign_in(resource_name, resource)
    # yield resource if block_given?
    # respond_with resource, location: after_sign_in_path_for(resource)
