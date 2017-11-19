require_relative 'boot'

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"

Bundler.require(*Rails.groups)

module NeoGql
  class Application < Rails::Application
    config.load_defaults 5.1
    config.api_only = true
    config.eager_load_paths << Rails.root.join('lib')
  end
end
