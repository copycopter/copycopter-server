class VersionsController < ApplicationController
  def create
    self.set_html_preference params[:prefer_html]
    @localization = Localization.find(params[:localization_id])
    @project = @localization.project
    authorize @project
    @version = @localization.revise(params[:version])
    @version.save!

    if @version.published?
      flash[:success] = 'Content published. ' +
        'It takes up to 5 minutes for new content to appear on the live site.'
    else
      flash[:success] = 'Draft saved.'
    end

    redirect_to new_localization_version_url(@localization)
  end

  def new
    @localization = Localization.find(params[:localization_id])
    @version = @localization.revise
    @project = @localization.project
    authorize @project
    @locale = @project.locale
  end
end
