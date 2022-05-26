require 'openssl'

OpenIDConnect.http_config do |config|
  config.ssl_config.verify_mode = OpenSSL::SSL::VERIFY_NONE if Rails.env.development?
end