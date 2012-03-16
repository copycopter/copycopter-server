class WoodHick < ActiveSupport::LogSubscriber
  def process_action(event)
    payload = event.payload

    if payload[:status]
      log payload[:status]
    end

    if payload[:exception]
      log payload[:exception].join('\n')
    end

    if payload[:path]
      log payload[:path]
    end
  end

  def log(message)
    puts "|=====> #{message}"
  end

  def logger
    ActionController::Base.logger
  end
end

if ENV['DEBUG']
  WoodHick.attach_to :action_controller
end
