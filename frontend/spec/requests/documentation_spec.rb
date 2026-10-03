require "rails_helper"

RSpec.describe DocumentationController, type: :request do
  describe "GET /documentation" do
    it "renders the documentation" do
      get "/documentation"

      expect(response).to have_http_status(200)
      expect(response.body).to have_css("#documentationPage[data-controller='documentation']")
      expect(response.body).to have_css("#loading", text: I18n.t('documentation.loading'))
    end
  end
end
