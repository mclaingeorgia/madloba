class ItemPolicy < ApplicationPolicy
  attr_reader :user, :item

  def initialize(user, item)
    @user = user
    @item = item
  end

  def index?
    user && user.super_admin?
  end

  def show?
    user && user.super_admin?
  end

  def create?
    new?
  end

  def new?
    user && user.super_admin?
  end

  def update?
    user && user.super_admin?
  end

  def edit?
    update?
  end

  def destroy?
    user && user.super_admin?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
