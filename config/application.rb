require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined? Bundler
  Bundler.require *Rails.groups(:assets => %w(development test))
end

module Copycopter
  class Application < Rails::Application
    config.action_view.javascript_expansions[:defaults] = %w()
    config.autoload_paths << Rails.root.join('lib').to_s
    config.eager_load_paths += %w(lib)
    config.encoding = 'utf-8'
    config.filter_parameters += [:password]
    config.assets.enabled = true
    config.assets.version = '1.0'
    config.assets.initialize_on_precompile = false

    config.generators do |generate|
      generate.test_framework :rspec
    end

    config.middleware.delete ActionDispatch::ParamsParser
  end
end
