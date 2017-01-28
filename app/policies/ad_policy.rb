class AdPolicy < ApplicationPolicy
  attr_reader :user, :post

  def initialize(user, post)
    @user = user
    @post = post
  end

  def owned
    user && (post.user_id == user.id)
  end

  def index?
    true
  end

  def show?
    (user && user.super_admin?) || (post.is_published == true) || owned
  end

  def create?
    new?
  end

  def new?
    user
  end

  def update?
    owned or (user && user.super_admin?)
  end

  def edit?
    update?
  end

  def destroy?
    owned or (user && user.super_admin?)
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
