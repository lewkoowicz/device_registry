class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_csrf_cookie
  before_action :set_locale

  private

  def set_csrf_cookie
    cookies['CSRF-TOKEN'] = form_authenticity_token
  end

  def set_locale
    I18n.locale = extract_locale_from_accept_language_header
  end

  def extract_locale_from_accept_language_header
    request.env['HTTP_ACCEPT_LANGUAGE']&.scan(/^[a-z]{2}/)&.first || I18n.default_locale
  end

  def authenticate_user!
    render json: { error: I18n.t('errors.unauthorized') }, status: :unauthorized unless current_user
  end

  def current_user
    @current_user ||= authenticate_user_from_session
  end

  def authenticate_user_from_session
    User.find_by(id: session[:user_id])
  end

  def user_signed_in?
    current_user.present?
  end

  def login(user)
    @current_user = user
    session[:user_id] = user.id
  end

  def logout
    @current_user = nil
    reset_session
  end

  def verified_request?
    super || valid_authenticity_token?(session, request.headers['X-CSRF-Token'])
  end
end