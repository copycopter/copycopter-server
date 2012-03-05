class WoodHick < ActiveSupport::LogSubscriber
  def process_action(event)
    payload = event.payload
    log payload[:status] if payload[:status]
    log payload[:exception].join('\n') if payload[:exception]
    log payload[:path] if payload[:path]
  end

  def log(message)
    puts "|=====> #{message}"
  end

  def logger
    ActionController::Base.logger
  end
end

WoodHick.attach_to :action_controller if ENV['DEBUG']
