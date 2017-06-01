class Users::ConfirmationsController < Devise::ConfirmationsController
  include Devisable

  def show
    authorize :user_confirmation
    super
  end

  def create
    authorize :user_confirmation
    self.resource = resource_class.send_confirmation_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
     # flash[:success] = t('devise.sessions.signed_in')
     render json: { reload: true, location: after_resending_confirmation_instructions_path_for(resource_name) }, status: :ok
    else
     render json: { flash: { error: resource.errors.full_messages.join(';') } }, status: :not_found
    end
  end
end
