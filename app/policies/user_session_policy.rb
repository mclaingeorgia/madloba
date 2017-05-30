class UserSessionPolicy < Struct.new(:user, :user_session)
  def new?
    true
  end

  def create?
    true
     # Rails.logger.debug("--------------------------------------------#{user.inspect} #{user.new_record?}")
    # user.new_record?
  end

  def failure?
    true
  end
  # def place?
  #   true
  # end

  # def faq?
  #   true
  # end

  # def privacy_policy?
  #   true
  # end

  # def terms_of_use?
  #   true
  # end
end
