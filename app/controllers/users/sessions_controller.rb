class Users::SessionsController < Devise::SessionsController
  include Devisable

  def create
    self.resource = warden.authenticate!({ scope: resource_name, recall: "#{controller_path}#failure" })
    sign_in(resource_name, resource)
    yield resource if block_given?
    set_flash_message!(:notice, :signed_in)
    render json: { reload: true, location: after_sign_in_path_for(resource) }, status: :ok
  end

  def failure
    render json: { flash: { error: t('devise.failure.invalid') } }, status: :unauthorized
  end
end
