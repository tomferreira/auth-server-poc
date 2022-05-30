class Admin::ProfilesController < ApplicationAdminController  
  def show
    @admin_info = session[:admin_info]
    @access_token = cookies[:access_token]
  end
end