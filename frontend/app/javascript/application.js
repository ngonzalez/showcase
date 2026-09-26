// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "controllers"

import "@hotwired/turbo-rails"

window['webRegistrationUrl'] = "http://192.168.1.11:3000/webRegistration.json"

window['verifyEmailAddress'] = "http://192.168.1.11:3000/verifyEmailAddress.json"
