class Admin::SessionsController < ApplicationAdminController
  skip_before_action :authenticate_admin!

  def new
    redirect_post "/admin/auth/internal-stage", options: {authenticity_token: :auto}
  end

  def create
    auth = request.env['omniauth.auth']

    reset_session
    session[:admin_info] = auth.info

    cookies.permanent[:access_token] = auth.credentials.token
    cookies.permanent[:id_token] = auth.credentials.id_token

    redirect_to admin_profile_path
  end

  def provider_logout
    # Add id token hint to omit the confirmation (in Keycloak) and do automatic redirect to the application
    # Based on OpenID Connect RP-Initiated Logout specification
    redirect_to "/admin/auth/internal-stage/logout?id_token_hint=#{cookies.permanent[:id_token]}", allow_other_host: true
  end

  def destroy
    cookies.delete(:access_token)
    cookies.delete(:id_token)
    
    reset_session

    redirect_to admin_root_path
  end

  def failure
    redirect_to admin_root_url, :alert => "Authentication error: #{params[:message].humanize}"
  end
end