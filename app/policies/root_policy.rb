class RootPolicy < Struct.new(:user, :root)
  def index?
    true
  end

  def about?
    true
  end

  def contact?
    true
  end

  def place?
    true
  end

  def faq?
    true
  end

  def privacy_policy?
    true
  end

  def terms_of_use?
    true
  end
end
