class SessionsController < Devise::SessionsController
  layout false
  clear_respond_to
  respond_to :html, :only => :new
  # respond_to :json, :js, :except => :show
  respond_to :js, :only => [:create, :failure] # :js, :html

  def create
    self.resource = warden.authenticate!({ scope: resource_name, recall: "#{controller_path}#failure" })
    # set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    yield resource if block_given?
    render json: { reload: true, location: after_sign_in_path_for(resource), flash: [{type: :success, text: t('devise.sessions.signed_in') }] }, status: :ok
  end

  def failure
    render json: { flash: [{type: :error, text: t('devise.failure.invalid') }] }, status: :unauthorized
   # render js: "console.log('test2'); pollution.components.flash.set([{type: 'error', text: '#{t('.unauthorized')}' }]).open()", status: :unauthorized
   # render :status => :unauthorized
  end
  # def new
  #   super do |resource|
  #     unless resource.new_record? && resource.valid?
  #       respond_with(resource, serialize_options(resource)) do |format|
  #         format.json { render :json => resource.errors, :status => :unauthorized }
  #       end
  #       return
  #     end
  #   end
  # end

  # new comment
 #  def new
 #    @post_url = params[:post]
 #    super
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
