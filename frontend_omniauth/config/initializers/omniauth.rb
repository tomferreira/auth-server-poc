Rails.application.config.middleware.use OmniAuth::Builder do

  provider :openid_connect, {
    name: :"internal-stage",
    path_prefix: "/admin/auth",
    issuer: "https://localhost:8443/auth/realms/internal-stage",
    discovery: true,
    scope: [:openid, :email, :profile, :offline_access, :roles],
    response_type: :code,
    post_logout_redirect_uri: "http://127.0.0.1:3000/admin/logout/callback",
    client_options: {
      port: 8443,
      scheme: "https",
      host: "localhost",
      identifier: "frontend_omniauth",
      secret: "oT1e8xk8nvn4HaVhUOe9Bk495PhT4wMR",
      redirect_uri: "http://127.0.0.1:3000/admin/auth/internal-stage/callback",
    },
  }

  provider :openid_connect, {
    name: :"member-stage",
    path_prefix: "/auth",
    issuer: "https://localhost:8443/auth/realms/member-stage",
    discovery: true,
    scope: [:openid, :email, :profile, :offline_access, :roles],
    response_type: :code,
    post_logout_redirect_uri: "http://127.0.0.1:3000/logout/callback",
    client_options: {
      port: 8443,
      scheme: "https",
      host: "localhost",
      identifier: "frontend_omniauth",
      secret: "xwhCEGIDQu48N24FFYiCdYSEaaX8Ll9k",
      redirect_uri: "http://127.0.0.1:3000/auth/member-stage/callback",
    },
  }
end