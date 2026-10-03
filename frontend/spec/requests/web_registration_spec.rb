require "rails_helper"

RSpec.describe WebRegistrationController, type: :request do
  let(:attributes) { user_attributes }
  let(:payload) { encode_payload(attributes) }

  describe "POST /web_registration" do
    context "when the backend creates the account" do
      let(:body) { web_registration_success_body }
      let!(:stub) { stub_web_registration_api(:web_registration, status: 200, body: body) }

      it "sends the Base64 encoded user details to the backend" do
        post "/web_registration", params: { user: attributes }

        expect(stub.with(body: { payload: payload }.to_json)).to have_been_requested.once
      end

      it "redirects to the confirmation page" do
        post "/web_registration", params: { user: attributes }

        expect(response).to redirect_to(confirmation_path(api_response: body.to_json, user: { payload: payload }))

        follow_redirect!
        expect(response).to have_http_status(200)
        expect(response.body).to have_css("[role='alert'] p", text: I18n.t('confirmation.text_1'))
      end
    end

    context "when the backend can't create the account" do
      before { stub_web_registration_api(:web_registration, status: 422, body: web_registration_fail_body) }

      it "redirects to the register page with an error notice" do
        post "/web_registration", params: { user: attributes }

        expect(response).to redirect_to(register_path(user: { payload: payload }))
        expect(flash[:notice]).to eq(I18n.t('web_registration.fail'))

        follow_redirect!
        expect(response.body).to have_css("[role='alert']", text: I18n.t('web_registration.fail'))
        expect(response.body).to have_css("form#registerForm")
        expect(response.body).not_to have_content(I18n.t('confirmation.text_1'))
      end
    end

    it "redirects to the register page without user details" do
      post "/web_registration"

      expect(response).to redirect_to(register_path)
      expect(a_request(:post, web_registration_api_url(:web_registration))).not_to have_been_made
    end

    it "returns a 502 HTTP code when the backend rejects the request" do
      stub_web_registration_api(:web_registration, status: 400)

      post "/web_registration", params: { user: attributes }

      expect(response).to have_http_status(502)
    end

    it "returns a 502 HTTP code when the backend can't be reached" do
      stub_request(:post, web_registration_api_url(:web_registration)).to_raise(Errno::ECONNREFUSED)

      post "/web_registration", params: { user: attributes }

      expect(response).to have_http_status(502)
    end
  end
end
