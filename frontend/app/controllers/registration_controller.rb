class RegistrationController < ApplicationController
  before_action :set_permitted_params, only: %i[index create]
  before_action :encode_user_payload, only: %i[index create]

  attr_accessor :permitted_params
  attr_accessor :user_payload

  def index
    redirect_to(register_path(user: { payload: user_payload }))
  end

  def create
    redirect_to(validate_path(user: { payload: user_payload }))
  end

  private

  def set_permitted_params
    @permitted_params = params[:user].permit! if params[:user]
  end

  def encode_user_payload
    @user_payload = Base64.encode64(params[:user].to_json) rescue {}
  end

  def company?
    permitted_params[:user].try(:accountType) == "company"
  end

  def person?
    permitted_params[:user].try(:accountType) == "person"
  end

  def user_account_type_params
    permitted_params[:user].slice([:accountType])
  end

  def user_params
    if person?
      permitted_params[:user].slice([
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
      permitted_params[:user].slice([
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
