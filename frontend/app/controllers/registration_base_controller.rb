class RegistrationBaseController < ApplicationController
  include UserPayloadConcern

  before_action :set_user_attributes, only: %i[create]
  before_action :require_user_attributes, only: %i[create]

  attr_accessor :user_attributes

  private

  def require_user_attributes
    redirect_to(register_path) if user_attributes.blank?
  end

  # Base64 encoded JSON object, as expected by the backend
  def backend_payload
    Base64.strict_encode64(user_attributes.to_json)
  end

  def web_registration_client
    WebRegistrationClient.new
  end
end
