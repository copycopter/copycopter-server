Copycopter::Application.configure do
  config.action_controller.perform_caching = true
  config.action_dispatch.x_sendfile_header = 'X-Sendfile'
  config.active_support.deprecation = :notify
  config.assets.enabled = false
  config.cache_classes = true
  config.consider_all_requests_local = false
  config.i18n.fallbacks = true
  config.serve_static_assets = false
end
