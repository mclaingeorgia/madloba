class ApplicationController < ActionController::Base
  include ApplicationHelper
  include Pundit
  after_action :verify_authorized

  protect_from_forgery

  PER_PAGE_COUNT = 6

  DEVISE_CONTROLLERS = ['users/sessions', 'users/registrations', 'users/passwords', 'users/confirmations']

  # before_filter :store_location

  # before_action :check_if_setup
  # before_action :allow_iframe_requests
  # before_action :load_javascript_text
  # before_action :set_flash
  # before_action :check_if_user_has_tos

  before_action :set_locale
  before_action :set_gon
  before_action :set_session
  before_action :prepare_about_content

  # include Pundit
  # include SimpleCaptcha::ControllerHelpers

  # helper :'user/location_form'

  layout :layout_by_resource

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

  def prepare_about_content
    @about_page = PageContent.by_name('about')
  end

  # Check if there is a cookie to define the locale to use.
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def set_gon
    gon.pin_path = ActionController::Base.helpers.asset_path('svg/pin.svg')
    gon.pin_highlight_path = ActionController::Base.helpers.asset_path('svg/pin_highlight.svg')
    gon.osm = 'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}'
    gon.osm_accessToken = 'pk.eyJ1IjoiY2h1bWJ1cmlkemUiLCJhIjoiSWVPV1k3TSJ9.W0UWrB5vpk4xz1Mq0L-xwg'
    gon.osm_id = 'chumburidze/cju2n8kjs09iw1fr1ykloty2r'
    # gon.osm = 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png'
    gon.osm_attribution = '<a href="https://openstreetmap.org/copyright">OpenStreetMap</a>'

    gon.labels = {}
  end
  def set_session
    # Rails.logger.debug("--------------------------------------------#{params.inspect}")
    if session[:user_return_to].present? && DEVISE_CONTROLLERS.index(params[:controller]).nil?
      # @post_action = session[:post_action]
      # Rails.logger.debug("--------------------------------------------post_action #{@post_action}")
      session.delete(:user_return_to)
    end
  end

  def default_url_options(options = {})
    { locale: I18n.locale }
  end




  private

  # Redirection when current user does not have the permission to go to
  # the requested page (authorization managed by Pundit)
  def user_not_authorized
    flash[:error] = t('config.not_authorized')
    redirect_to(request.referrer || root_path || user_path)
  end

  def layout_by_resource
    if !DEVISE_CONTROLLERS.index(params[:controller]).nil? && request.xhr?
      false
    else
      'application'
    end
  end

  protected

  # Method to render 404 page
    def render_not_found(exception)
      @class='error'
      ExceptionNotifier.notify_exception(exception, env: request.env, :data => {:message => "was doing something wrong"})
      respond_to do |format|
        format.html { render template: 'errors/error404', status: 404 }
        format.json { render json: { flash: { error: t('errors.not_found') } }, status: 404 }
        format.all { render nothing: true, status: 404}
      end
    end

    # Method to render 500 page
    def render_error(exception)
      @class='error'
      ExceptionNotifier.notify_exception(exception, env: request.env)
      respond_to do |format|
        format.html { render template: 'errors/error500', status: 500 }
        format.json { render json: { flash: { error: t('errors.server_error') } }, status: 500 }
        format.all { render nothing: true, status: 500}
      end
    end
end
