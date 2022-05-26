Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resource :profile, only: [:show]

  get "auth/:provider/callback", to: "sessions#create"
  get "/logout/callback", to: "sessions#destroy"

  get "/login", to: "sessions#new"
  get "/logout", to: "sessions#provider_logout"

  root "profiles#show"
end
