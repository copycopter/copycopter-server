class FakeJobQueue
  def enqueue(*args)
    options = args.extract_options!
    options[:payload_object] ||= args.shift
    yaml = YAML.dump(options[:payload_object])
    job = YAML.load(yaml)
    job.perform
  end
end
