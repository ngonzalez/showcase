class RegistrationBaseController < ApplicationController
  include UserPayloadConcern

  before_action :set_user_attributes, only: %i[create]
  before_action :require_user_attributes, only: %i[create]

  attr_accessor :user_attributes

  private

  def require_user_attributes
    redirect_to(register_path) if user_attributes.blank?
  end

  # JSON object encrypted with the key shared with the backend
  def backend_payload
    EncryptHelpers.encrypt(user_attributes.to_json, key: WEB_REGISTRATION_ENCRYPTION_KEY)
  end

  def web_registration_client
    WebRegistrationClient.new
  end
end
