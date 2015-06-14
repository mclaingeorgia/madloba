class AdminPolicy < ApplicationPolicy
  attr_reader :user, :admin

  def initialize(user, admin)
    @user = user
    @admin = admin
  end

  def managerecords?
    user.admin? || user.super_admin?
  end

  def manageusers?
    user.admin? || user.super_admin?
  end

  def generalsettings?
    user.admin? || user.super_admin?
  end

  def mapsettings?
    user.admin? || user.super_admin?
  end

  def areasettings?
    user.admin? || user.super_admin?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
