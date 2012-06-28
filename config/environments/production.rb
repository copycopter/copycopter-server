Copycopter::Application.configure do
  config.action_controller.perform_caching = true
  config.action_dispatch.x_sendfile_header = 'X-Sendfile'
  config.active_support.deprecation = :notify
  config.assets.enabled = true
  config.cache_classes = true
  config.consider_all_requests_local = false
  config.i18n.fallbacks = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Generate digests for assets URLs
  config.assets.digest = true

  # Add the print CSS into the manifest
  config.assets.precompile += ['wysiwyg.css']
end
