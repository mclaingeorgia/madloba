class UserPasswordPolicy < Struct.new(:user, :user_password)

  def create?
    true
  end

  def update?
    true
  end
end
