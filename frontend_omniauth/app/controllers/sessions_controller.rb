class SessionsController < ApplicationController
  skip_before_action :authenticate_user!

  def new
    redirect_post "/auth/keycloak", options: {authenticity_token: :auto}
  end

  def create
    auth = request.env['omniauth.auth']

    reset_session
    session[:user_info] = auth.info

    cookies.permanent[:access_token] = auth.credentials.token
    cookies.permanent[:id_token] = auth.credentials.id_token

    redirect_to profile_path
  end

  def provider_logout
    # Add id token hint to omit the confirmation (in Keycloak) and do automatic redirect to the application
    # Based on OpenID Connect RP-Initiated Logout specification
    redirect_to "/auth/keycloak/logout?id_token_hint=#{cookies.permanent[:id_token]}", allow_other_host: true
  end

  def destroy
    cookies.delete(:access_token)
    cookies.delete(:id_token)
    
    reset_session

    redirect_to root_path
  end
end