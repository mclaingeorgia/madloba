class Users::RegistrationsController < Devise::RegistrationsController
  include Devisable

  def new
    build_resource({})
    yield resource if block_given?
    # resource.providers << Provider.new
    respond_with resource
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

  # def sign_up_params
  #   params.require(:user).permit(:first_name, :first_name_en, :first_name_ka,
  #                                :last_name, :last_name_en, :last_name_ka, :username, :email,
  #                                :password, :password_confirmation, :role, :is_service_provider, :has_agreed_to_tos)
  # end

  # def account_update_params
  #   params.require(:user).permit(:first_name, :first_name_en, :first_name_ka,
  #                                :last_name, :last_name_en, :last_name_ka, :username, :email,
  #                                :password, :password_confirmation, :current_password, :role, :is_service_provider, :has_agreed_to_tos)
  # end

end
