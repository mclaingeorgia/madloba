class UploadPolicy < ApplicationPolicy

  def create?
    user.at_least_user?
  end

  def upload_state_update?
    user.at_least_provider?
  end

end

