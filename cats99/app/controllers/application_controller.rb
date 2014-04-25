class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :logged_in?, :logout, :session_user

  def login!(user)
    session[:token] = user.reset_session_token!
    @session = user
  end
  def session_user
    @session ||= User.find_by_session_token(session[:token])
  end

  def logged_in?
    !!session_user
  end

  def logout
    session_user.try(:reset_session_token!)
  end
end
