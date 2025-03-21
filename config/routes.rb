Rails.application.routes.draw do
  # root route
  root "feed#show"

  get "sign_up", to: "users#new"
  post "sign_up", to: "users#create"
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  # Rails health check
  get "up" => "rails/health#show", as: :rails_health_check
end
