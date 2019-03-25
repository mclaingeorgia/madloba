class ServicePolicy < ApplicationPolicy

  def index?
    user.admin?
  end

  def new?
    user.admin?
  end

  def create?
    user.admin?
  end

  def edit?
    user.admin?
  end

  def update?
    user.admin?
  end

  def destroy?
    user.admin?
  end

  def move_up?
    user.admin?
  end

  def move_down?
    user.admin?
  end

end
