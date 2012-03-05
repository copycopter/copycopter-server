class Api::V2::PublishedBlurbsController < Api::V2::BaseController
  def index
    if stale? :etag => current_project.etag
      render :json => current_project.published_json
    end
  end
end
