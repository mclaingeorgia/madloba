class CategoryPolicy < ApplicationPolicy
  attr_reader :user, :category

  def initialize(user, category)
    @user = user
    @category = category
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
