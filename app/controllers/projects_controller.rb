class ProjectsController < ApplicationController
  before_filter :authorize, :only => [:show]

  def index
    @projects = Project.active
  end

  def show
    @project = Project.find(params[:id])
    @locale = @project.locale(params[:locale_id])

    if stale? :etag => @project.etag
      @localizations = @project.localizations.includes(:blurb).in_locale(@locale).ordered
    end
  end

end
