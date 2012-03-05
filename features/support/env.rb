require 'rubygems'
require 'spork'

Spork.prefork do
  require 'cucumber/rails'
  Capybara.default_selector = :css
  Capybara.server_boot_timeout = 30
  Capybara.save_and_open_page_path = 'tmp'
  Capybara.javascript_driver = :webkit
  $LOAD_PATH << Rails.root.join('spec', 'support').to_s
end

Spork.each_run do
  ActionController::Base.allow_rescue = false
  Cucumber::Rails::World.use_transactional_fixtures = true
  require 'database_cleaner'
  DatabaseCleaner.strategy = :truncation
  DatabaseCleaner.clean
end
