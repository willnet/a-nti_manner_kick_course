require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

if ENV["INJECT_ANTI_MANNER"]
  ActionController::Base
end

module Dummy
  class Application < Rails::Application
    config.load_defaults Rails::VERSION::STRING.to_f
    config.autoload_lib(ignore: %w[assets tasks])
  end
end
