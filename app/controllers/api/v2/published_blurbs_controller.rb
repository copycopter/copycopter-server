class Api::V2::PublishedBlurbsController < Api::V2::BaseController
  def index
    if stale? :etag => current_project.etag
      if params[:format] == "hierarchy"
        render :json => current_project.published_json(:hierarchy => true)
      else
        render :json => current_project.published_json
      end
    end
  end
end
