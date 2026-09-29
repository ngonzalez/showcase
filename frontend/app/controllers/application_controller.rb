class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  rescue_from Error::WebRegistration::InvalidRequest,
              with: :bad_gateway

  rescue_from ActiveRecord::RecordNotFound,
              with: :not_found

  private

  %i[bad_gateway not_found].each do |status|
    define_method(status) do |_exception|
      head(status)
    end
  end
end
