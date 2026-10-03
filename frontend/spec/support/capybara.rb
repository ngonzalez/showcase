require 'capybara/rspec'

# Capybara matchers (have_css, have_field, have_select, have_link...) parse
# the rendered HTML, e.g. `expect(response.body).to have_field("user[city]")`
RSpec.configure do |config|
  config.include Capybara::RSpecMatchers, type: :request
end
