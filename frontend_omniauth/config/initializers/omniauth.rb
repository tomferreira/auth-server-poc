Rails.application.config.middleware.use OmniAuth::Builder do

  provider :openid_connect, {
    name: :keycloak,
    issuer: "https://localhost:8443/realms/pier-stage",
    discovery: true,
    scope: [:openid, :email, :profile, :offline_access, :roles],
    response_type: :code,
    post_logout_redirect_uri: "http://127.0.0.1:3000/logout/callback",
    client_options: {
      port: 8443,
      scheme: "https",
      host: "localhost",
      identifier: "frontend_omniauth",
      secret: "nZtAwJB3uhY0ez8tyTEyyXzkkJqVPaw4",
      redirect_uri: "http://127.0.0.1:3000/auth/keycloak/callback",
    },
  }
end