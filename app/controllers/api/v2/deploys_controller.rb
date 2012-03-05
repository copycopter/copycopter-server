class Api::V2::DeploysController < Api::V2::BaseController
  def create
    JOB_QUEUE.enqueue DeployJob.new(current_project)
    render :json => '', :status => 201
  end
end
