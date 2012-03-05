Then /^I should receive a file named "([^"]+)"$/ do |file_name|
  content_disposition = page.response_headers['Content-Disposition']
  content_disposition.should include %{filename="#{file_name}"}
end
