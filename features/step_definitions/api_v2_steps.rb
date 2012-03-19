When /^I GET the v2 API URI for "([^"]*)" draft blurbs( with a "([^"]*)" param)?$/ do |project_name, skip, param|
  project = Project.find_by_name!(project_name)
  if param
    get_with_etag "/api/v2/projects/#{project.api_key}/draft_blurbs?#{param}"
  else
    get_with_etag "/api/v2/projects/#{project.api_key}/draft_blurbs"
  end
end

When /^I GET the v2 API URI for "([^"]*)" published blurbs( with a "([^"]*)" param)?$/ do |project_name, skip, param|
  project = Project.find_by_name!(project_name)
  if param
    get_with_etag "/api/v2/projects/#{project.api_key}/published_blurbs?#{param}"
  else
    get_with_etag "/api/v2/projects/#{project.api_key}/published_blurbs"
  end
end

When /^I GET the v2 API URI for "([^"]*)" published blurbs twice$/ do |project_name|
  project = Project.find_by_name!(project_name)
  2.times { get "/api/v2/projects/#{project.api_key}/published_blurbs" }
end

When /^I GET the v2 API URL for an unknown project's draft blurbs$/ do
  get_with_etag "/api/v2/projects/bogus_api_key/draft_blurbs"
end

When /^I GET the v2 API URL for an unknown project's published blurbs$/ do
  get_with_etag "/api/v2/projects/bogus_api_key/published_blurbs"
end

When /^I POST the v2 API URI for "([^"]*)" deploys$/ do |project_name|
  project = Project.find_by_name!(project_name)
  post "/api/v2/projects/#{project.api_key}/deploys", ''
end

When /^I POST the v2 API URI for "([^"]*)" draft blurbs:$/ do |project_name, table|
  hash = table.transpose.hashes.first
  json = Yajl::Encoder.encode(hash)
  project = Project.find_by_name!(project_name)
  post "/api/v2/projects/#{project.api_key}/draft_blurbs", json
end

When /^I POST the v2 API URI for an unknown project's deploys$/ do
  post '/api/v2/projects/bogus_api_key/deploys', ''
end

When /^I POST the v2 API URI for an unknown project's draft blurbs$/ do
  post "/api/v2/projects/bogus_api_key/draft_blurbs", "{}"
end

Then /^I should receive the following as a JSON object:$/ do |table|
  expected_hash = table.transpose.hashes.first
  actual_result = Yajl::Parser.parse(page.source)
  actual_result.should == expected_hash
end

Then /^I should receive the following JSON response:$/ do |string|
  actual_result = JSON.parse(page.source)
  actual_result.should == JSON.parse(string)
end

Then /^the response should be wrapped in a "([^"]*)" callback function$/ do |callback_function|
  page.source =~ /^#{callback_function}/
end

