require_relative "boot"
require "rails"

Bundler.require(*Rails.groups)

if ENV["INJECT_ANTI_MANNER"]
  ActiveSupport.run_load_hooks(:action_controller, "dummy")
end

module Dummy
  class Application < Rails::Application
    config.eager_load = false
  end
end
