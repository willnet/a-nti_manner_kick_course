class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser is only available in Rails 7.2+
  allow_browser versions: :modern if respond_to?(:allow_browser)
end
