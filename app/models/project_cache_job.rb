class ProjectCacheJob
  def initialize(project_id)
    @project_id = project_id
  end

  def perform
    project.update_caches
  rescue ActiveRecord::RecordNotFound
  end

  private

  def project
    Project.find @project_id
  end
end
