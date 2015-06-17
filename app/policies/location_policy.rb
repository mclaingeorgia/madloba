class LocationPolicy < ApplicationPolicy
  attr_reader :user, :location

  def initialize(user, location)
    @user = user
    @location = location
  end

  def owned
    user && (location.user_id == user.id)
  end

  def index?
    true
  end

  def show?
    user && (owned or user.super_admin?)
  end

  def create?
    new?
  end

  def new?
    user && (user.user? or user.super_admin?)
  end

  def update?
    user && (owned or user.super_admin?)
  end

  def edit?
    update?
  end

  def destroy?
    user && (owned or user.super_admin?)
  end

  class Scope < Scope
    def resolve
      if user && user.super_admin?
        scope.all
      else
        scope.where(user_id: user.id)
      end
    end
  end

end
