class ApplicationAdminController < ActionController::Base
    # Prevent CSRF attacks by raising an exception.
    protect_from_forgery with: :exception
    
    before_action :authenticate_admin!
  
    protected
  
    def authenticate_admin!
      redirect_to admin_login_path unless current_admin # TODO: Verify expiration token
    end
  
    def current_admin
      session[:admin_info]
    end
  end
  