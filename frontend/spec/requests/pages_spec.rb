require "rails_helper"

RSpec.describe PagesController, type: :request do
  let(:attributes) { user_attributes }

  %w[/ /home].each do |path|
    describe "GET #{path}" do
      it "renders the home page" do
        get path

        expect(response).to have_http_status(200)
        expect(response.body).to have_css("p", text: I18n.t('home.service_name'))
        expect(response.body).to have_link(href: plans_path)
      end
    end
  end

  describe "GET /plans" do
    it "renders the plans" do
      get "/plans"

      expect(response).to have_http_status(200)
      expect(response.body).to have_css("h2", text: I18n.t('choose_plan.premium_5GB.name'))
    end
  end

  describe "GET /register" do
    it "renders the registration form" do
      get "/register"

      expect(response).to have_http_status(200)
      expect(response.body).to have_css("form#registerForm[method='post'][action='#{verify_email_address_path}']")
      expect(response.body).to have_field("user[accountType]", type: "radio", with: "person")
      expect(response.body).to have_field("user[accountType]", type: "radio", with: "company")
      %w[companyName firstName lastName emailAddress address postalCode city].each do |name|
        expect(response.body).to have_field("user[#{name}]")
      end
      expect(response.body).to have_select("user[country]")
      expect(response.body).to have_field("user[password]", type: "password")
      expect(response.body).to have_field("user[passwordConfirmation]", type: "password")
    end

    it "selects the default plan without plan" do
      get "/register"

      expect(response.body).to have_select("user[plan]", options: ["Premium 5GB"], selected: "Premium 5GB")
    end

    it "selects the plan" do
      get "/register", params: { plan: "10GB" }

      expect(response.body).to have_select("user[plan]", options: ["Premium 10GB"], selected: "Premium 10GB")
    end

    it "selects the default plan for an unknown plan" do
      get "/register", params: { plan: "1TB" }

      expect(response.body).to have_select("user[plan]", selected: "Premium 5GB")
    end

    it "is linked from the plans" do
      get "/plans"

      expect(response.body).to have_link(href: register_path(plan: "5GB"))
      expect(response.body).to have_link(href: register_path(plan: "10GB"))
    end
  end

  describe "GET /validate" do
    let(:api_response) { verify_email_address_body.to_json }
    let(:payload) { encrypt_payload(attributes) }

    it "renders the details to validate" do
      get "/validate", params: { api_response: api_response, user: { payload: payload } }

      expect(response).to have_http_status(200)
      %i[companyName firstName lastName emailAddress address postalCode city country plan].each do |name|
        expect(response.body).to have_css("td", text: attributes[name])
      end
      expect(response.body).to have_link(I18n.t('steps.register'), href: register_path(plan: "10GB"))
      expect(response.body).not_to have_css("#errorMessages")
    end

    it "submits the encrypted payload only to the web registration" do
      get "/validate", params: { api_response: api_response, user: { payload: payload } }

      expect(response.body).to have_css("form#validateForm[method='post'][action='#{web_registration_path}']")
      expect(response.body).to have_field("user[payload]", type: :hidden, with: payload, visible: :hidden)
      expect(response.body).to have_css("form#validateForm input[name^='user[']", visible: :all, count: 1)
      expect(response.body).to not_expose_password(attributes)
    end

    it "doesn't render the company name for a person" do
      get "/validate", params: { api_response: api_response, user: { payload: encrypt_payload(user_attributes(accountType: "person")) } }

      expect(response.body).not_to have_content("Example Company")
      expect(response.body).to have_css("td", text: "Anna")
    end

    it "renders the account and user errors" do
      api_response = verify_email_address_body(
        verify_account: ["Address can't be blank"],
        verify_user: ["Email address has already been taken"]
      ).to_json

      get "/validate", params: { api_response: api_response, user: { payload: payload } }

      expect(response.body).to have_css("#errorMessages li", count: 2)
      expect(response.body).to have_css("#errorMessages li", text: "Address can't be blank")
      expect(response.body).to have_css("#errorMessages li", text: "Email address has already been taken")
    end

    it "redirects to the register page without payload" do
      get "/validate", params: { api_response: api_response }

      expect(response).to redirect_to(register_path)
    end

    {
      "a Base64 payload" => -> { Base64.strict_encode64(user_attributes.to_json) },
      "a tampered payload" => -> { iv, value = encrypt_payload(user_attributes).split(":"); [iv, value.reverse].join(":") },
      "a payload encrypted with another key" => -> { "77dbdd89282548b91213af93c2a6883a:d82390e2b3afa8133a3324cc92d6d0f7" },
      "a payload that isn't hex" => -> { "not:hex" },
      "an encrypted payload that isn't JSON" => -> { EncryptHelpers.encrypt("not json") },
      "an encrypted payload that isn't a JSON object" => -> { EncryptHelpers.encrypt([1, 2].to_json) },
    }.each do |description, invalid_payload|
      it "redirects to the register page for #{description}" do
        get "/validate", params: { api_response: api_response, user: { payload: instance_exec(&invalid_payload) } }

        expect(response).to redirect_to(register_path)
      end
    end

    it "returns a 502 HTTP code without API response" do
      get "/validate", params: { user: { payload: payload } }

      expect(response).to have_http_status(502)
    end

    it "returns a 502 HTTP code for an API response that isn't JSON" do
      get "/validate", params: { api_response: "not json", user: { payload: payload } }

      expect(response).to have_http_status(502)
    end
  end

  describe "GET /confirmation" do
    let(:api_response) { web_registration_success_body.to_json }

    it "renders the confirmation" do
      get "/confirmation", params: { api_response: api_response }

      expect(response).to have_http_status(200)
      %w[text_1 text_2 text_3].each do |key|
        expect(response.body).to have_css("[role='alert'] p", text: I18n.t("confirmation.#{key}"))
      end
    end

    it "returns a 502 HTTP code for an API response that isn't JSON" do
      get "/confirmation", params: { api_response: "not json" }

      expect(response).to have_http_status(502)
    end
  end

  it "rejects browsers that aren't modern" do
    get "/", headers: { "User-Agent" => "Mozilla/5.0 (Windows NT 6.1; Trident/7.0; rv:11.0) like Gecko" }

    expect(response).to have_http_status(406)
  end
end
