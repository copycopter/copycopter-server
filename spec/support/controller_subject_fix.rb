module ControllerSubjectFix
  def subject
    controller
  end
end

RSpec.configure do |config|
  config.include ControllerSubjectFix,
    :example_group => { :file_path => %r{spec/controllers} }
end
