class Api::V2::DeploysController < Api::V2::BaseController
  def create
    current_project.deploy!
    render json: '', :status => 201
  end
end
