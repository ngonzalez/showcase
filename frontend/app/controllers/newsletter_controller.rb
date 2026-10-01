class NewsletterController < ApplicationController
  before_action :set_email_address, only: %i[create]

  def create
    redirect_to(home_path,
      notice: "%s: %s" % [I18n.t('newsletter.success'), @email_address]
    )
  end

  private

  def set_email_address
    @email_address = params[:email_address]
  end
end
