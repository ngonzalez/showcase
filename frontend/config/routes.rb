
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
  get "plans" => "pages#plans", as: "plans"
  get "register" => "pages#register", as: "register"
  get "validate" => "pages#validate", as: "validate"
  get "confirmation" => "pages#confirmation", as: "confirmation"

  # Web Registration
  post "verify_email_address" => "verify_email_address#create"
  post "web_registration" => "web_registration#create"

  # Documentation
  get "documentation" => "documentation#index", as: "documentation"

  # Newsletter
  post "newsletter" => "newsletter#create", as: "newsletter"
end
