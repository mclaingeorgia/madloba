class Users::SessionsController < Devise::SessionsController
  respond_to :json # :js, :html


  # new comment
 #  def new
 #    @post_url = params[:post]
 #    super
 #  end

 #  def create
 #    # pars = params.permit(:authenticity_token, :locale)
 #     Rails.logger.debug("--------------------------------------------1#{params.inspect}")
 #     begin
 #        self.resource = warden.authenticate!(auth_options, action: "#{controller_path}#failure")
 #     rescue  => e
 #       Rails.logger.debug("--------------------------------------------#{e.inspect}")
 #     end
 #       Rails.logger.debug("--------------------------------------------#{self.resource}")
 #    # resource = User.find_for_database_authentication(email: params[:user][:email])
 #    Rails.logger.debug("--------------------------------------------1.1")
 #    return invalid_login_attempt unless resource

 #    Rails.logger.debug("--------------------------------------------2")
 #    if resource.valid_password?(params[:user][:password])
 #      sign_in(resource_name, resource)
 #      # Rails.logger.debug("--------------------------------------------4#{after_sign_in_path_for(resource)}")
 #      # redirect_to :back
 #      Rails.logger.debug("--------------------------------------------5")
 #      render :js => 'location.reload();'
 #      #return render nothing: true
 #    else
 #      Rails.logger.debug("--------------------------------------------6")
 #      invalid_login_attempt
 #    end
 #      #respond_with resource, location: after_sign_in_path_for(resource)
 # end

 #  def destroy
 #    super
 #  end

 #  def failure
 #    # Rails.logger.debug("--------------------------------------------#{self.errors.inspect}")
 #    render js: 'shared/error', status: 401
 #    # :js => { :errors => self.flash.to_hash, sessions: true }, :status => :error
 #  end
 #  # protected

 #  def invalid_login_attempt
 #    # set_flash_message(:alert, :invalid)
 #    Rails.logger.debug("--------------------------------------------7")
 #    render js: 'shared/error', status: 401
 #    Rails.logger.debug("--------------------------------------------8")
 #  end


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


    # self.resource = warden.authenticate!(auth_options)
    # set_flash_message!(:notice, :signed_in)
    # sign_in(resource_name, resource)
    # yield resource if block_given?
    # respond_with resource, location: after_sign_in_path_for(resource)
