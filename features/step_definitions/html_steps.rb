Then %r{^I should see "([^"]*)" before "([^"]*)"$} do |text1, text2|
  response_body.should =~ %r{#{Regexp.escape(text1)}.*?#{Regexp.escape(text2)}}m
end

Then /^I should see a submit input "([^"]*)"$/ do |content|
  page.should have_css("input[type='submit'][value='#{content}']")
end

Then /^the "([^"]*)" button should be disabled$/ do |content|
  page.should have_css("input[type='submit'][disabled='disabled'][value='#{content}']")
end

Then /^no visible elements should contain "([^"]*)"$/ do |text|
  elements = page.all(:xpath, %{//*[contains(child::text(), "#{text}")]})

  elements.each do |element|
    Capybara.timeout { !element.visible? }
  end
end

Then /^a visible element should contain "([^"]*)"$/ do |text|
  elements = page.all(:xpath, %{//*[contains(child::text(), "#{text}")]})

  if elements.empty?
    raise "No elements found containing #{text.inspect}"
  elsif elements.none? { |element| element.visible? }
    raise "Elements containing #{text.inspect} were all invisible"
  end
end

When /^I clear the "([^"]*)" field$/ do |label|
  step %{I type "" into "#{label}"}
end

When /^I type "([^"]*)" into "([^"]+)"/ do |text, label|
  field = find_field(label)
  field.set text
  field.trigger 'keyup'
  sleep 1
end

When /^I focus the "([^"]*)" field$/ do |label|
  field = find_field(label)
  field.trigger 'focus'
end
