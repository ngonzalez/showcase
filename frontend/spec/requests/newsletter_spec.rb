require "rails_helper"

RSpec.describe NewsletterController, type: :request do
  describe "POST /newsletter" do
    it "redirects to the home page with a notice" do
      post "/newsletter", params: { email_address: "anna.smith@example.com" }

      expect(response).to redirect_to(home_path)
      expect(flash[:notice]).to eq("#{I18n.t('newsletter.success')}: anna.smith@example.com")
    end

    it "renders the notice on the home page" do
      post "/newsletter", params: { email_address: "anna.smith@example.com" }
      follow_redirect!

      expect(response.body).to have_css("[role='alert']", text: "#{I18n.t('newsletter.success')}: anna.smith@example.com")
    end

    it "is submitted by the footer form with the field the controller reads" do
      get "/"

      expect(response.body).to have_css("footer form[action='#{newsletter_path}'][method='post']")
      expect(response.body).to have_field("email_address", type: "email")
    end
  end
end
