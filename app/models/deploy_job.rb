class DeployJob
  def initialize(project)
    @project = project
  end

  def perform
    @project.deploy!
  end
end
