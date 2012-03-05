Then /^the "([^"]*)" field within ([^"].*) should contain "([^"]*)"$/ do |label, named_element, expected_value|
  selector = selector_for(named_element)

  within selector do
    field = find_field(label)
    field_value = (field.tag_name == 'textarea') ? field.text : field.value
    field_value.should include(expected_value)
  end
end

When /^I follow "([^"]+)" within ([^"].*)$/ do |link_text, named_element|
  selector = selector_for(named_element)

  within selector do
    click_link link_text
  end
end

When /^I fill in "([^"]+)" with "([^"]+)" within ([^"].*)$/ do |field, value, named_element|
  selector = selector_for(named_element)

  within selector do
    fill_in field, :with => value
  end
end

Then /^(.*) should not be visible$/ do |named_element|
  selector = selector_for(named_element)

  verify_with_timeout(selector, "#{selector} should be hidden") do |element|
    !element.visible?
  end
end

Then /^(.*) should be visible$/ do |named_element|
  selector = selector_for(named_element)

  verify_with_timeout(selector, "#{selector} should be visible") do |element|
    element.visible?
  end
end

When /^I click ([^"].*)$/ do |named_element|
  selector = selector_for(named_element)
  find(selector).click
end

Then /^I should see "([^"]*)" within ([^"].*)$/ do |content, named_element|
  within selector_for(named_element) do
    page.should have_content(content)
  end
end

Then /^I should not see "([^"]*)" within ([^"].*)$/ do |content, named_element|
  within selector_for(named_element) do
    page.should have_no_content(content)
  end
end
