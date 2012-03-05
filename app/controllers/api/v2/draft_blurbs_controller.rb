class Api::V2::DraftBlurbsController < Api::V2::BaseController
  def index
    if stale? :etag => current_project.etag
      render :json => current_project.draft_json
    end
  end

  def create
    current_project.create_defaults parse_json
    render :json => '', :status => :created
  end

  private

  def parse_json
    Yajl::Parser.parse request.raw_post
  end
end
