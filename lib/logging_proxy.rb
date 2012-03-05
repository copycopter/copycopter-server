class LoggingProxy
  instance_methods.each do |method|
    unless method =~ /(^__|^send$|^object_id$|^extend$|^tap$)/
      undef_method method
    end
  end

  def initialize(target, logger = nil)
    @target = target
    @logger = logger
  end

  def method_missing(name, *args, &block)
    logger.debug "#{inspect_target}##{name}(#{inspect_args(args)})"
    result = @target.send(name, *args, &block)
    logger.debug "=> #{result.inspect}"
    result
  end

  private

  def inspect_target
    @target.class.name
  end

  def inspect_args(args)
    args.map(&:inspect).join ', '
  end

  def logger
    @logger || Rails.logger
  end
end
