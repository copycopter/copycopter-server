class AllowRescue
  def initialize(app)
    @app = app
  end

  def call(env)
    env['action_dispatch.show_exceptions'] = !!ActionController::Base.allow_rescue
    @app.call env
  end
end

Capybara.app = AllowRescue.new(Capybara.app)
