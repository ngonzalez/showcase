require "rails_helper"

RSpec.describe WebRegistrationClient do
  subject(:client) { described_class.new }

  let(:payload) { encrypt_backend_payload(user_attributes) }

  {
    verify_email_address: { success: -> { verify_email_address_body }, failure: -> { verify_email_address_body(verify_user: ["Email address has already been taken"]) } },
    web_registration: { success: -> { web_registration_success_body }, failure: -> { web_registration_fail_body } },
  }.each do |endpoint, bodies|
    describe "##{endpoint}" do
      let(:url) { web_registration_api_url(endpoint) }

      it "posts the payload with the API token" do
        stub = stub_web_registration_api(endpoint, status: 200, body: instance_exec(&bodies[:success]))

        client.public_send(endpoint, payload)

        expect(
          stub.with(
            body: { payload: payload }.to_json,
            headers: {
              'Authorization' => "Bearer #{NGINX_WEB_REGISTRATION_TOKEN}",
              'Content-Type' => 'application/json',
              'Accept' => 'application/json',
            }
          )
        ).to have_been_requested.once
      end

      it "returns a successful response for a 200 HTTP code" do
        body = instance_exec(&bodies[:success])
        stub_web_registration_api(endpoint, status: 200, body: body)

        response = client.public_send(endpoint, payload)

        expect(response).to be_success
        expect(response.status).to eq(200)
        expect(response.body).to eq(JSON.parse(body.to_json))
      end

      it "returns an unsuccessful response for a 422 HTTP code" do
        body = instance_exec(&bodies[:failure])
        stub_web_registration_api(endpoint, status: 422, body: body)

        response = client.public_send(endpoint, payload)

        expect(response).not_to be_success
        expect(response.status).to eq(422)
        expect(response.body).to eq(JSON.parse(body.to_json))
      end

      [400, 401, 404, 500, 502].each do |status|
        it "raises InvalidResponse for a #{status} HTTP code" do
          stub_web_registration_api(endpoint, status: status)

          expect { client.public_send(endpoint, payload) }
            .to raise_error(Error::Http::InvalidResponse, "#{endpoint}: unexpected HTTP status #{status}")
        end
      end

      it "raises InvalidResponse for a body that isn't JSON" do
        stub_request(:post, url).to_return(status: 200, body: "<html></html>")

        expect { client.public_send(endpoint, payload) }
          .to raise_error(Error::Http::InvalidResponse, "#{endpoint}: invalid JSON body")
      end

      [
        Net::OpenTimeout,
        Net::ReadTimeout,
        Errno::ECONNREFUSED,
        SocketError,
        OpenSSL::SSL::SSLError,
        EOFError,
      ].each do |error|
        it "raises InvalidRequest on #{error}" do
          stub_request(:post, url).to_raise(error)

          expect { client.public_send(endpoint, payload) }.to raise_error(Error::Http::InvalidRequest)
        end
      end

      it "uses SSL by default" do
        stub_web_registration_api(endpoint, status: 200, body: instance_exec(&bodies[:success]))
        expect(Net::HTTP).to receive(:start).with(NGINX_WEB_REGISTRATION_HOST, NGINX_WEB_REGISTRATION_PORT.to_i, hash_including(use_ssl: true)).and_call_original

        client.public_send(endpoint, payload)
      end

      context "with the http protocol, for a backend running locally" do
        before { stub_const("NGINX_WEB_REGISTRATION_PROTOCOL", "http") }

        it "posts to the http URL without SSL" do
          stub = stub_web_registration_api(endpoint, status: 200, body: instance_exec(&bodies[:success]))
          expect(Net::HTTP).to receive(:start).with(NGINX_WEB_REGISTRATION_HOST, NGINX_WEB_REGISTRATION_PORT.to_i, hash_including(use_ssl: false)).and_call_original

          expect(client.public_send(endpoint, payload)).to be_success
          expect(stub).to have_been_requested.once
          expect(url).to start_with("http://")
        end
      end

      it "doesn't hide programming errors as network errors" do
        allow(Net::HTTP).to receive(:start).and_raise(NoMethodError)

        expect { client.public_send(endpoint, payload) }.to raise_error(NoMethodError)
      end
    end
  end
end
