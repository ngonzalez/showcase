require "rails_helper"

RSpec.describe VerifyEmailAddressController, type: :request do
  let(:attributes) { user_attributes }
  let(:payload) { encode_payload(attributes) }

  describe "POST /verify_email_address" do
    context "with valid details" do
      let!(:stub) { stub_web_registration_api(:verify_email_address, status: 200, body: verify_email_address_body) }

      it "sends the Base64 encoded user details to the backend" do
        post "/verify_email_address", params: { user: attributes }

        expect(stub.with(body: { payload: payload }.to_json)).to have_been_requested.once
      end

      it "redirects to the validate page with the API response" do
        post "/verify_email_address", params: { user: attributes }

        expect(response).to redirect_to(
          validate_path(api_response: verify_email_address_body.to_json, user: { payload: payload })
        )
      end

      it "renders the details to validate without errors" do
        post "/verify_email_address", params: { user: attributes }
        follow_redirect!

        expect(response).to have_http_status(200)
        expect(response.body).to have_field("user[companyName]", type: :hidden, with: "Example Company", visible: :hidden)
        expect(response.body).to have_field("user[emailAddress]", type: :hidden, with: "anna.smith@example.com", visible: :hidden)
        expect(response.body).not_to have_css("#errorMessages")
      end
    end

    context "with an existing email address" do
      before do
        stub_web_registration_api(:verify_email_address, status: 422,
          body: verify_email_address_body(verify_user: ["Email address has already been taken"]))
      end

      it "renders the backend errors on the validate page" do
        post "/verify_email_address", params: { user: attributes }
        follow_redirect!

        expect(response).to have_http_status(200)
        expect(response.body).to have_css("#errorMessages li", count: 1, text: "Email address has already been taken")
      end
    end

    context "with invalid account details" do
      before do
        stub_web_registration_api(:verify_email_address, status: 422,
          body: verify_email_address_body(verify_account: ["Address can't be blank"]))
      end

      it "renders the backend errors on the validate page" do
        post "/verify_email_address", params: { user: attributes.except(:address) }
        follow_redirect!

        expect(response.body).to have_css("#errorMessages li", count: 1, text: "Address can't be blank")
      end
    end

    it "redirects to the register page without user details" do
      post "/verify_email_address"

      expect(response).to redirect_to(register_path)
      expect(a_request(:post, web_registration_api_url(:verify_email_address))).not_to have_been_made
    end

    it "returns a 502 HTTP code when the backend rejects the request" do
      stub_web_registration_api(:verify_email_address, status: 400)

      post "/verify_email_address", params: { user: attributes }

      expect(response).to have_http_status(502)
    end

    it "returns a 502 HTTP code when the backend can't be reached" do
      stub_request(:post, web_registration_api_url(:verify_email_address)).to_timeout

      post "/verify_email_address", params: { user: attributes }

      expect(response).to have_http_status(502)
    end
  end
end
