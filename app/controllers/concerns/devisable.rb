module Devisable
  extend ActiveSupport::Concern

  included do
    layout :determine_layout

    before_action :determine_page_type, only: [:new, :edit]

    clear_respond_to
    respond_to :html, :only => [:new, :edit]
    respond_to :json, :only => [:create, :failure, :update]

  end

  private
    def determine_layout
      %w(new).include?(action_name) && request.xhr? ? false : 'application'
    end
    def determine_page_type
      @form_container_class = ['pad']
      @form_container_class << :'autonomous' if request.xhr?
      @form_class = :'light'
      # @class = "devise"
    end
end
