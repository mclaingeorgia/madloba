class AdminController < ApplicationController
 before_action :authenticate_user!
 before_action :set_admin_flag

  # before_filter :requires_user

  # include ApplicationHelper

  # # Style used to display messages on 'Area settings' page
  # STYLES = {success: 'text-success', error: 'text-danger' }

  # def requires_user
  #   if !user_signed_in?
  #     redirect_to '/user/login'
  #   end
  # end

  # def index
  #   @messages = []
  #   if (current_user.super_admin?)
  #     # To-do list creation
  #     Todo.all.each do |todo|
  #       @messages << todo.message_and_alert if !todo.condition_met?
  #     end
  #   end
  # end
  def set_admin_flag
    @is_admin = true
  end

  def index
    redirect_to admin_profile_path
  end

  def user_profile
    @class = 'user_profile'

    @edit = params[:edit] == 'true'

    @type = params[:type].present? && !['favorite-places', 'rated-places', 'uploaded-photos'].index(params[:type]).nil? ? params[:type] : 'favorite-places'

  end

  def provider_profile

    @class = 'provider_profile'

    @id = params[:id]

    @type = params[:type].present? && !['manage-provider', 'manage-places', 'moderate-photos'].index(params[:type]).nil? ? params[:type] : 'manage-provider'

    @edit_states = [false, false, false]
    if @id.present?
      if @type == 'manage-provider'
        @edit_states[0] = true
        @item = Provider.find(@id)
      end
      @edit_states[1] = true if @type == 'manage-places'
      @edit_states[2] = true if @type == 'moderate-photos'
    end

    @providers = Provider.by_user(current_user.id) # with places included


  end

  def admin_profile
    @class = 'admin_profile'
  end
end
