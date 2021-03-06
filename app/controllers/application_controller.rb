# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::Cookies
  include ActionController::RequestForgeryProtection

  before_action :set_csrf_cookie
  protect_from_forgery with: :exception

  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user
    User.find_by(id: session[:user_id])
  end

  def logged_in?
    !!current_user
  end

  def authorize_resource(resource)
    raise ActiveRecord::RecordInvalid if !current_user || resource.user != current_user
  end

  def authenticate
    raise AppError::AuthenticationError if !logged_in?
  end

  def not_authorized
    render json: {error: "Not Authorized"}, status: 401
  end

  private

  def set_csrf_cookie
    cookies['CSRF-TOKEN'] = form_authenticity_token
  end
end
