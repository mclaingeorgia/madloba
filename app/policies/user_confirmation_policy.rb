class UserConfirmationPolicy < Struct.new(:user, :user_confirmation)
  def show?
    true
  end

  def create?
    true
  end
end
