class AdminPolicy < ApplicationPolicy
  attr_reader :user, :admin

  def initialize(user, admin)
    @user = user
    @admin = admin
  end

  def managerecords?
    user.super_admin?
  end

  def manageusers?
    user.super_admin?
  end

  def generalsettings?
    user.super_admin?
  end

  def mapsettings?
    user.super_admin?
  end

  def areasettings?
     user.super_admin?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
