class ProjectsController < ApplicationController
  before_filter :authorize, :only => [:destroy, :edit, :show, :update]

  def destroy
    project = Project.find(params[:id])
    project.destroy
    redirect_to projects_url
  end

  def edit
    @project = Project.find(params[:id])
  end

  def index
    @projects = Project.active
  end

  def new
    @project = Project.new
  end

  def show
    @project = Project.find(params[:id])
    @locale = @project.locale(params[:locale_id])

    if stale? :etag => @project.etag
      @localizations = @project.localizations.in_locale(@locale).ordered
    end
  end

  def update
    @project = Project.find(params[:id])

    if @project.update_attributes params[:project]
      redirect_to @project
    else
      render :action => :edit
    end
  end
end
