# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "lodash" # @4.18.1
pin "marked" # @18.0.14
pin_all_from "app/javascript/controllers", under: "controllers"
