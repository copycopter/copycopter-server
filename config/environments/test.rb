require 'logging_proxy'
require 'fake_job_queue'

Copycopter::Application.configure do
  config.action_controller.allow_forgery_protection = false
  config.action_controller.perform_caching = false
  config.action_dispatch.show_exceptions = true
  config.active_support.deprecation = :stderr
  config.cache_classes = true
  config.consider_all_requests_local = true
  config.whiny_nils = true

  config.after_initialize do
    JOB_QUEUE = FakeJobQueue.new
  end
end
