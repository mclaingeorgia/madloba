class RootController < ApplicationController
  include ApplicationHelper
  # before_action :set_page_content, only: [:index, :faq, :privacy_policy, :terms_of_use]

  def index
  end

  def about
    render :action => 'index', locals: { dialog_trigger_type: :about }
  end

  def contact
    render :action => 'index', locals: { dialog_trigger_type: :contact }
  end

  def faq
    @class = "faq"
    gon.is_faq_page = true
    @page_content = PageContent.by_name('faq')
  end

  def privacy_policy
    @class = "privacy_policy"
    @page_content = PageContent.by_name('privacy_policy')
  end

  def terms_of_use
    @class = "terms_of_use"
    @page_content = PageContent.by_name('terms_of_use')
  end

  def place
    id = params[:id]
    item = Place.authorized_by_id(id)

    if item.present?
      locals({
        item: item
      })
    else
      redirect_to root_path, flash: { error:  t('app.messages.not_found', obj: Place) }
    end
  end

  private

    def locals(values)
      render locals: values
    end

  # def set_page_content
  #   @about_page_content = PageContent.by_name('about')
  # end
end
