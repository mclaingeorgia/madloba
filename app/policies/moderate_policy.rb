class ModeratePolicy < ApplicationPolicy

  def permitted
    user.admin?
  end

  def place_service?
    permitted
  end

  def place_report?
    permitted
  end

  def place_report_update?
    permitted
  end

  def place_ownership?
    permitted
  end

  def place_ownership_update?
    permitted
  end

  def new_provider?
    permitted
  end

  def new_provider_update?
    permitted
  end

  def place_tag?
    permitted
  end

  def place_tag_update?
    permitted
  end
end

