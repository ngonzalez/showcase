class WebRegistrationController < ApplicationController

  before_action :create_job, only: %i[create]

  def create
    redirect_to(confirmation_path)
  end

  private
  
  def create_job
    WebRegistrationJob.new({}.to_json).perform
  end

end
