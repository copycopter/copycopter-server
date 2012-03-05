class LocalesController < ApplicationController
  before_filter :authorize

  def new
    @project = Project.find(params[:project_id])
  end
end
