class UserPolicy < ApplicationPolicy

  def index?
    user.admin?
  end

  def new?
    user.admin?
  end

  def create?
    user.admin?
  end

  def permitted
    (user.at_least_user? && user == record) || user.admin?
  end

  def edit?
    permitted
  end

  def update?
    permitted
  end

  def destroy?
    user.admin?
  end

  def restore?
    user.admin?
  end

  def user_profile?
    user.at_least_user?
  end

  def provider_profile?
    user.at_least_provider?
  end
  def autocomplete_user?
    user.at_least_provider?
  end
  def autocomplete_place?
    user.at_least_provider?
  end
end
