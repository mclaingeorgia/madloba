module Devisable
  extend ActiveSupport::Concern

  included do
    layout :determine_layout

    before_action :determine_page_type, only: [:new, :edit]

    clear_respond_to

    respond_to :html, :only => [:new, :edit]
    respond_to :json, :only => [:create, :failure, :update]


    unless Rails.application.config.consider_all_requests_local
      rescue_from Exception,
                  :with => :render_error
      rescue_from StandardError,
                  :with => :render_error
      rescue_from ActiveRecord::RecordNotFound,
                  :with => :render_not_found
      rescue_from ActionController::RoutingError,
                  :with => :render_not_found
      rescue_from ActionController::UnknownController,
                  :with => :render_not_found
      rescue_from Pundit::NotAuthorizedError,
                  with: :user_not_authorized
    end

  end

  private
    def determine_layout
      %w(new).include?(action_name) && request.xhr? ? false : 'application'
    end
    def determine_page_type
      @class = 'devise'
      @form_container_class = []
      if request.xhr?
        @form_container_class << :'autonomous'
      else
        @form_container_class << 'pad'
      end
      @form_container_class << :'border' if ["registrations/new", "registrations/create"].index("#{controller_name}/#{action_name}").nil?

      @form_class = :'light'
      # @class = "devise"
    end

    # Method to render 404 page
    def render_not_found(exception)
      ExceptionNotifier.notify_exception(exception, env: request.env, :data => {:message => "was doing something wrong"})

      respond_to do |format|
        format.html { render template: 'errors/error404', status: 404 }
        format.json { render json: { flash: { error: t('errors.not_found') } }, status: 404 }
        format.all { render nothing: true, status: 404}

      end
    end

    # Method to render 500 page
    def render_error(exception)
      ExceptionNotifier.notify_exception(exception, env: request.env)
      respond_to do |format|
        format.html { render template: 'errors/error500', status: 500 }
        format.json { render json: { flash: { error: t('errors.server_error') } }, status: 500 }
        format.all { render nothing: true, status: 500}
      end
    end
end
