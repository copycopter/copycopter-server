class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :prefer_html?
  hide_action :prefer_html?, :set_html_preference

  def prefer_html?
    session[:html_preference] == 'true'
  end

  def set_html_preference(preference)
    session[:html_preference] = preference
  end

  private

  def authenticate(project)
    unless Rails.env.test?
      authenticate_or_request_with_http_basic do |username, password|
        username == project.username && password == project.password
      end
    end
  end

  def authorize
    project = find_by_localization_id || find_by_project_id || find_by_id
    authenticate project
  end

  def find_by_id
    Project.find params[:id]
  end

  def find_by_localization_id
    if params[:localization_id]
      Localization.find(params[:localization_id]).project
    end
  end

  def find_by_project_id
    if params[:project_id]
      Project.find params[:project_id]
    end
  end
end
