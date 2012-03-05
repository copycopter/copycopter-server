module NavigationHelpers
  def path_to(page_name)
    case page_name
    when /the blurbs index for the "([^"]+)" project/i
      project = Project.find_by_name!($1)
      project_path project
    when /the dashboard page/
      dashboard_path
    when /the edit blurb page for "(.+)" on "(.+)"/i
      project = Project.find_by_name!($2)
      blurb = project.blurbs.find_by_key!($1)
      locale = project.locales.enabled_in_order.first
      localization = blurb.localizations.find_by_locale_id!(locale.id)
      new_localization_version_path localization
    when /^the home ?page$/i
      root_path
    when /marketing/i
      root_path
    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send path_components.push('path').join('_').to_sym
      rescue Object => e
        raise %{Can't find "#{page_name}" mapping. Add it in #{__FILE__}.}
      end
    end
  end
end

World NavigationHelpers
