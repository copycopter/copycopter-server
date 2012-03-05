module RoutingHelpers
  def add_routes(&block)
    routes = Rails.application.routes
    begin
      routes.disable_clear_and_finalize = true
      routes.clear!
      Rails.application.routes_reloader.paths.each { |path| load(path) }
      routes.draw(&block)
      routes.finalize!
    ensure
      routes.disable_clear_and_finalize = false
    end
  end

  def reset_routes
    Rails.application.reload_routes!
  end
end

RSpec.configure do |config|
  config.include RoutingHelpers
end
