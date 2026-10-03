require "rails_helper"

RSpec.describe PagesController, type: :request do
  let(:attributes) { user_attributes }
  let(:payload) { encode_payload(attributes) }

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

    it "selects the default plan without payload" do
      get "/register"

      expect(response.body).to have_select("user[plan]", options: ["Premium 5GB"], selected: "Premium 5GB")
    end

    it "selects the plan from the payload" do
      get "/register", params: { user: { payload: encode_payload(plan: "10GB") } }

      expect(response.body).to have_select("user[plan]", options: ["Premium 10GB"], selected: "Premium 10GB")
    end

    it "selects the default plan for an unknown plan" do
      get "/register", params: { user: { payload: encode_payload(plan: "1TB") } }

      expect(response.body).to have_select("user[plan]", selected: "Premium 5GB")
    end

    it "selects the default plan for a payload that isn't Base64 JSON" do
      get "/register", params: { user: { payload: "not json" } }

      expect(response).to have_http_status(200)
      expect(response.body).to have_select("user[plan]", selected: "Premium 5GB")
    end
  end

  describe "GET /validate" do
    let(:api_response) { verify_email_address_body.to_json }

    it "renders the details to validate in the web registration form" do
      get "/validate", params: { api_response: api_response, user: { payload: payload } }

      expect(response).to have_http_status(200)
      expect(response.body).to have_css("form#validateForm[method='post'][action='#{web_registration_path}']")
      attributes.each do |name, value|
        expect(response.body).to have_field("user[#{name}]", type: :hidden, with: value, visible: :hidden)
      end
      expect(response.body).to have_link(I18n.t('steps.register'), href: register_path(user: { payload: payload }))
      expect(response.body).not_to have_css("#errorMessages")
    end

    it "doesn't render the company name for a person" do
      get "/validate", params: { api_response: api_response, user: { payload: encode_payload(user_attributes(accountType: "person")) } }

      expect(response.body).not_to have_field("user[companyName]", visible: :all)
      expect(response.body).to have_field("user[firstName]", type: :hidden, with: "Anna", visible: :hidden)
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
      get "/confirmation", params: { api_response: api_response, user: { payload: payload } }

      expect(response).to have_http_status(200)
      %w[text_1 text_2 text_3].each do |key|
        expect(response.body).to have_css("[role='alert'] p", text: I18n.t("confirmation.#{key}"))
      end
    end

    it "redirects to the register page without payload" do
      get "/confirmation", params: { api_response: api_response }

      expect(response).to redirect_to(register_path)
    end

    it "returns a 502 HTTP code for an API response that isn't JSON" do
      get "/confirmation", params: { api_response: "not json", user: { payload: payload } }

      expect(response).to have_http_status(502)
    end
  end

  it "rejects browsers that aren't modern" do
    get "/", headers: { "User-Agent" => "Mozilla/5.0 (Windows NT 6.1; Trident/7.0; rv:11.0) like Gecko" }

    expect(response).to have_http_status(406)
  end
end
