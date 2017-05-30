class UserPolicy < ApplicationPolicy
  attr_reader :user

  # def initialize(current_user, model)
  #   @current_user = current_user
  #   @user = model
  # end

  # def index?
  # end

  # def show?
  #   @current_user == @user || (@current_user && @current_user.admin?)
  # end

  # def create?
  #   new?
  # end

  def new?
    true
    # @current_user && @current_user.admin?
  end

  # def update?
  #   edit?
  # end

  # def edit?
  #   @current_user == @user || (@current_user && @current_user.admin?)
  # end

  # def destroy?
  #   return false if @current_user == @user
  #   (@current_user && @current_user.admin?)
  # end

  def user_profile?
    user.at_least_user?
  end

  def provider_profile?
    user.at_least_provider?
  end
end
