class RegistrationController < ApplicationController
  before_action :permit_params, only: %i[create]
  before_action :set_session_user_payload, only: %i[create]

  def index
    redirect_to(register_path)
  end

  def create
    redirect_to(validate_path)
  end

  private

  def permit_params
    params[:user].permit!
  end

  def set_session_user_payload
    session[:userPayload] = user_payload
  end

  def user_payload
    Base64.encode64(params[:user].to_json) rescue {}
  end

  def company?
    params[:user].try(:accountType) == "company"
  end

  def person?
    params[:user].try(:accountType) == "person"
  end

  def user_account_type_params
    params[:user].slice([:accountType])
  end

  def user_params
    if person?
      params[:user].slice([
        :firstName,
        :lastName,
        :emailAddress,
        :address,
        :postalCode,
        :city,
        :country,
        :plan,
        :password,
        :passwordConfirmation
      ])
    elsif company?
      params[:user].slice([
        :companyName,
        :emailAddress,
        :address,
        :postalCode,
        :city,
        :country,
        :plan,
        :password,
        :passwordConfirmation
      ])
    end
  end
end
