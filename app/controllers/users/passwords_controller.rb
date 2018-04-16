class Users::PasswordsController < Devise::PasswordsController
  include Devisable

  def new
    authorize :user_password
    super
  end

  def create
    authorize :user_password
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
     # flash[:success] = t('devise.sessions.signed_in')
     render json: { reload: true, location: after_sending_reset_password_instructions_path_for(resource_name) }, status: :ok
    else
     render json: { flash: { error: resource.errors.full_messages.join(';') } }, status: :not_found
    end
  end

  def edit
    authorize :user_password
    self.resource = resource_class.new
    set_minimum_password_length
    resource.reset_password_token = params[:reset_password_token]
  end

  def update
    authorize :user_password
    self.resource = resource_class.reset_password_by_token(resource_params)
    yield resource if block_given?

    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)
      if Devise.sign_in_after_reset_password
        flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
        set_flash_message!(:notice, flash_message)
        sign_in(resource_name, resource)
      else
        set_flash_message!(:notice, :updated_not_active)
      end
      render json: { reload: true, location: after_resetting_password_path_for(resource_name) }, status: :ok
      # respond_with resource, location: after_resetting_password_path_for(resource)
    else
      set_minimum_password_length
      render json: { flash: { error: resource.errors.full_messages.join(';') } }, status: :not_found
      # respond_with resource
    end
  end
end
