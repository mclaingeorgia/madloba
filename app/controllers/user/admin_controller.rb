class User::AdminController < ApplicationController
 before_action :authenticate_user!
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
  def index
  end
end
