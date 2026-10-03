require "rails_helper"

RSpec.describe ApplicationController, type: :controller do
  controller do
    def index
      raise ActiveRecord::RecordNotFound
    end

    def show
      raise Error::Http::InvalidRequest
    end
  end

  it "returns a 404 HTTP code when a record isn't found" do
    get :index

    expect(response).to have_http_status(404)
  end

  it "returns a 502 HTTP code when a request to the backend fails" do
    get :show, params: { id: 1 }

    expect(response).to have_http_status(502)
  end
end
