class RootController < ApplicationController
  include ApplicationHelper
  before_action :set_page_content, only: [:index, :faq, :privacy_policy, :terms_of_service]

  def index
  end

  # def about
  # end

  def faq
    @faq_page_content = PageContent.by_name('about')
  end

  # def contact
  # end

  def privacy_policy
  end

  def terms_of_service
  end

  private

  def set_page_content
    @about_page_content = PageContent.by_name('about')
  end
end
