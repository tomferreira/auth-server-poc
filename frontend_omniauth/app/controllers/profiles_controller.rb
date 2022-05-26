class ProfilesController < ApplicationController  
  def show
    @user_info = session[:user_info]
    @access_token = cookies[:access_token]
  end
end