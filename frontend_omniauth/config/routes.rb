Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resource :profile, only: [:show]

  get "/auth/:provider/callback", to: "sessions#create"
  get "/auth/failure" => "sessions#failure"
  
  get "/login", to: "sessions#new"
  get "/logout", to: "sessions#provider_logout"
  get "/logout/callback", to: "sessions#destroy"

  root "profiles#show"

  namespace :admin do
    resource :profile, only: [:show]

    get "/auth/:provider/callback", to: "sessions#create"
    get "/auth/failure" => "sessions#failure"

    get "/login", to: "sessions#new"
    get "/logout", to: "sessions#provider_logout"
    get "/logout/callback", to: "sessions#destroy"

    root "profiles#show"
  end
end
