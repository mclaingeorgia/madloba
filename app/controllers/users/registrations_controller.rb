class Users::RegistrationsController < Devise::RegistrationsController
  include Devisable

  def new
    build_resource({})
    resource.providers.build
    yield resource if block_given?
    respond_with resource
  end
  def create
    pars = sign_up_params
    build_resource(pars)
    # resource.providers.build
    #resource.providers.build({name_ka: "ab", description_ka: 'asdf'})
     # Rails.logger.debug("--------------------------------------------#{resource.providers.inspect}")
    # resource.build_provider

    # resource.providers.build
     # Rails.logger.debug("--------------------------------------------#{pars[:providers_attributes]}")
    # resource.providers.build({ providers_attributes: pars[:providers_attributes] })
    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        render json: { reload: true, location: after_sign_up_path_for(resource_name) }, status: :ok
        # respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        render json: { reload: true, location: after_inactive_sign_up_path_for(resource_name) }, status: :ok
        # respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      # respond_with resource
      render json: { flash: { error: format_messages(resource) } }, status: :not_found
    end
  end
  # def new
  #   super
  # end

  # def update
  #   super
  # end

  # protected

  # def after_inactive_sign_up_path_for(resource)
  #   if request.referer.include? 'setup'
  #     setup_done_path
  #   else
  #     root_path
  #   end
  # end

  # private

  def sign_up_params
    permitted = User.globalize_attribute_names + [:username, :email, :password, :password_confirmation, :is_service_provider, :has_agreed, providers_attributes: Provider.globalize_attribute_names ]
    p = params.require(:user).permit(*permitted)
    p["providers_attributes"].reject! { |attr| attr.empty? }
    p
  end

  # def account_update_params
  #   params.require(:user).permit(:first_name, :first_name_en, :first_name_ka,
  #                                :last_name, :last_name_en, :last_name_ka, :username, :email,
  #                                :password, :password_confirmation, :current_password, :role, :is_service_provider, :has_agreed_to_tos)
  # end

end

#first_name_ka, last_name_ka, first_name_en, last_name_en, username, is_service_provider, providers_attributes, has_agreed
