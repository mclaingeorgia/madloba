class UserRegistrationPolicy < Struct.new(:user, :user_registration)
  def new?
    true
  end

  def create?
    true
  end
end
