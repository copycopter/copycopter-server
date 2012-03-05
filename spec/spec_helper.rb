require 'rubygems'
require 'spork'

ENV['RAILS_ENV'] = 'test'

Spork.prefork do
  require File.expand_path('../../config/environment', __FILE__)
  require 'rspec/rails'
  Dir[Rails.root.join('spec/support/**/*.rb')].each {|f| require f}

  RSpec.configure do |config|
    config.mock_with :mocha
    config.fixture_path = "#{::Rails.root}/spec/fixtures"
    config.use_transactional_fixtures = true
    config.backtrace_clean_patterns << %r{gems/}
  end
end

Spork.each_run do
end

