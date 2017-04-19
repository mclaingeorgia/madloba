class RootController < ApplicationController
  include ApplicationHelper
  # before_action :set_page_content, only: [:index, :faq, :privacy_policy, :terms_of_use]

  def index
  end

  # def about
  # end

  def faq
    @class = "faq"
    @page_content = PageContent.by_name('faq')
     Rails.logger.debug("--------------------------------------------#{@page_content}")
  end

  # def contact
  # end

  def privacy_policy
    @class = "privacy_policy"
    @page_content = PageContent.by_name('privacy_policy')
  end

  def terms_of_use
    @class = "terms_of_use"
    @page_content = PageContent.by_name('terms_of_use')
  end

  private

  # def set_page_content
  #   @about_page_content = PageContent.by_name('about')
  # end
end
