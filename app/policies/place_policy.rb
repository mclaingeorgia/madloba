class PlacePolicy < ApplicationPolicy

  # def list?
  #   user.at_least_provider?
  # end

  def index?
    user.admin?
  end

  def new?
    user.at_least_provider?
  end

  def create?
    new?
  end

  def permitted
    (user.provider? && record.provider.users.include(user)) || user.admin?
  end

  def edit?
    permitted
  end

  def update?
    permitted
  end

  def destroy?
    permitted
  end

  def restore?
    user.admin?
  end

end

