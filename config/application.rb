require File.expand_path('../boot', __FILE__)

require 'rails'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'rails/test_unit/railtie'

if defined? Bundler
  Bundler.require :default, Rails.env
end

module Copycopter
  class Application < Rails::Application
    config.action_view.javascript_expansions[:defaults] = %w()
    config.autoload_paths << Rails.root.join('lib').to_s
    config.eager_load_paths += %w(lib)
    config.encoding = 'utf-8'
    config.filter_parameters += [:password]

    config.generators do |generate|
      generate.test_framework :rspec
    end

    config.middleware.delete ActionDispatch::ParamsParser
  end
end
