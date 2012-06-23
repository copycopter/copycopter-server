class Api::V2::DraftBlurbsController < Api::V2::BaseController
  def index
    if stale? etag: current_project.etag
      if  params[:format] == "hierarchy"
        render json: current_project.draft_json(hierarchy: true), callback: params[:callback]
      else
        render json: current_project.draft_json, callback: params[:callback]
      end
    end
  end

  def create
    current_project.create_defaults parse_json
    render json: '', :status => :created
  end

  private

  def parse_json
    Yajl::Parser.parse request.raw_post
  end
end
