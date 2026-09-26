
# == Route Map
#

Rails.application.routes.draw do
  default_url_options(
    host: NGINX_HOST,
    port: NGINX_PORT,
    protocol: :https
  )

  root to: "pages#home"

  # Pages
  get "home" => "pages#home", as: "home"
  get "register" => "pages#register", as: "register"
  get "plans" => "pages#plans", as: "plans"
  get "validate" => "pages#validate", as: "validate"
  get "confirmation" => "pages#confirmation", as: "confirmation"

  # Registration
  get "registration" => "registration#index", as: "registration_redirect"
  post "registration" => "registration#create", as: "registration"

  # Documentation
  get "documentation" => "documentation#index", as: "documentation"

  # Newsletter
  post "newsletter" => "newsletter#create", as: "newsletter"
end
