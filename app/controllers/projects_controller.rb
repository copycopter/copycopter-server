class ProjectsController < ApplicationController
  before_filter :authorize, :only => [:show]

  def index
    @projects = Project.active
  end

  def show
    @project = Project.find(params[:id])
    @locale = @project.locale(params[:locale_id])

    if stale? :etag => @project.etag
      @localizations = @project.localizations.in_locale_with_blurb(@locale)
    end
  end

end
