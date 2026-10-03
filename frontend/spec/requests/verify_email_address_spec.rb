require "rails_helper"

RSpec.describe VerifyEmailAddressController, type: :request do
  let(:attributes) { user_attributes }

  describe "POST /verify_email_address" do
    context "with valid details" do
      let!(:stub) { stub_web_registration_api(:verify_email_address, status: 200, body: verify_email_address_body) }

      it "sends the user details encrypted with the shared key to the backend" do
        post "/verify_email_address", params: { user: attributes }

        expect(stub.with { |request| backend_payload_attributes(request) == attributes }).to have_been_requested.once
        expect(stub.with { |request| request.body.match?(/#{attributes[:password]}/) }).not_to have_been_requested
      end

      it "redirects to the validate page with the API response and the encrypted user details" do
        post "/verify_email_address", params: { user: attributes }

        expect(response).to have_http_status(302)
        expect(URI(response.location).path).to eq(validate_path)
        expect(redirect_params["api_response"]).to eq(verify_email_address_body.to_json)
        expect(decrypt_payload(redirect_params["user"]["payload"])).to eq(attributes)
        expect(response.location).to not_expose_password(attributes)
      end

      it "renders the details to validate without errors" do
        post "/verify_email_address", params: { user: attributes }
        follow_redirect!

        expect(response).to have_http_status(200)
        expect(response.body).to have_css("td", text: "Example Company")
        expect(response.body).to have_css("td", text: "anna.smith@example.com")
        expect(response.body).not_to have_css("#errorMessages")
        expect(response.body).to not_expose_password(attributes)
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
