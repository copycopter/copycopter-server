require 'fake_job_queue'

Copycopter::Application.configure do
  config.action_controller.perform_caching = false
  config.action_dispatch.best_standards_support = :builtin
  config.active_support.deprecation = :log
  config.cache_classes = false
  config.consider_all_requests_local = true
  config.whiny_nils = true

  config.after_initialize do
    ::JOB_QUEUE = FakeJobQueue.new
  end
end
