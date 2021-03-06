class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  def login(user)
    session[:session_token] = SessionToken.where(user_id: user.id).order(:updated_at).last.token
  end

  def logout(user)
    logout_token = session[:session_token]
    SessionToken.find_by(token: logout_token).destroy
    session[:session_token] = nil
  end

  def current_user
    @current_user ||= User.joins(:session_tokens).where("session_tokens.token = ?", session[:session_token]).last
  end
end
