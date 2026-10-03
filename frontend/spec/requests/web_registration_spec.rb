require "rails_helper"

RSpec.describe WebRegistrationController, type: :request do
  let(:attributes) { user_attributes }
  let(:payload) { encrypt_payload(attributes) }

  describe "POST /web_registration" do
    context "when the backend creates the account" do
      let(:body) { web_registration_success_body }
      let!(:stub) { stub_web_registration_api(:web_registration, status: 200, body: body) }

      it "sends the decrypted user details, Base64 encoded, to the backend" do
        post "/web_registration", params: { user: { payload: payload } }

        expect(stub.with(body: { payload: encode_payload(attributes) }.to_json)).to have_been_requested.once
      end

      it "redirects to the confirmation page" do
        post "/web_registration", params: { user: { payload: payload } }

        expect(response).to redirect_to(confirmation_path(api_response: body.to_json))
        expect(response.location).to not_expose_password(attributes)

        follow_redirect!
        expect(response).to have_http_status(200)
        expect(response.body).to have_css("[role='alert'] p", text: I18n.t('confirmation.text_1'))
      end
    end

    context "when the backend can't create the account" do
      before { stub_web_registration_api(:web_registration, status: 422, body: web_registration_fail_body) }

      it "redirects to the register page of the plan with an error notice" do
        post "/web_registration", params: { user: { payload: payload } }

        expect(response).to redirect_to(register_path(plan: "10GB"))
        expect(flash[:notice]).to eq(I18n.t('web_registration.fail'))

        follow_redirect!
        expect(response.body).to have_css("[role='alert']", text: I18n.t('web_registration.fail'))
        expect(response.body).to have_select("user[plan]", selected: "Premium 10GB")
        expect(response.body).not_to have_content(I18n.t('confirmation.text_1'))
      end
    end

    {
      "without user details" => -> { {} },
      "with user details in clear" => -> { { user: user_attributes } },
      "with a Base64 payload" => -> { { user: { payload: encode_payload(user_attributes) } } },
      "with a payload that can't be decrypted" => -> { { user: { payload: "77dbdd89282548b91213af93c2a6883a:d82390e2b3afa8133a3324cc92d6d0f7" } } },
    }.each do |description, params|
      it "redirects to the register page #{description}" do
        post "/web_registration", params: instance_exec(&params)

        expect(response).to redirect_to(register_path)
        expect(a_request(:post, web_registration_api_url(:web_registration))).not_to have_been_made
      end
    end

    it "returns a 502 HTTP code when the backend rejects the request" do
      stub_web_registration_api(:web_registration, status: 400)

      post "/web_registration", params: { user: { payload: payload } }

      expect(response).to have_http_status(502)
    end

    it "returns a 502 HTTP code when the backend can't be reached" do
      stub_request(:post, web_registration_api_url(:web_registration)).to_raise(Errno::ECONNREFUSED)

      post "/web_registration", params: { user: { payload: payload } }

      expect(response).to have_http_status(502)
    end
  end
end
