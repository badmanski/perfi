class ApplicationController < ActionController::Base
  include SentientController

  before_filter :authenticate_user!
  before_filter :configure_permitted_params, if: :devise_controller?
  before_filter :allow_resource_params

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  after_filter :set_csrf_cookie_for_ng

  add_flash_types :success, :error

  rescue_from CanCan::AccessDenied do |e|
    redirect_to root_url, error: e.message
  end

  def set_csrf_cookie_for_ng
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end

  protected

  def verified_request?
    super || form_authenticity_token == request.headers['X-XSRF-TOKEN']
  end

  def configure_permitted_params
    devise_parameter_sanitizer.for(:sign_up) << :name
    devise_parameter_sanitizer.for(:sign_up) << :name
    devise_parameter_sanitizer.for(:account_update) << :name
  end

  private

  def allow_resource_params
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end
end
