class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  protect_from_forgery with: :exception
  
  before_action :authenticate_user!

  protected

  def authenticate_user!
    redirect_to login_path unless current_user # TODO: Verify expiration token
  end

  def current_user
    session[:user_info]
  end
end
