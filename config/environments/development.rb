Copycopter::Application.configure do
  config.assets.enabled = true
  config.action_controller.perform_caching = false
  config.action_dispatch.best_standards_support = :builtin
  config.active_support.deprecation = :log
  config.cache_classes = false
  config.consider_all_requests_local = true
  config.whiny_nils = true
  config.assets.debug = true
  config.assets.compress = false
end
