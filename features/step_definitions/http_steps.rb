Then /^I should receive a HTTP (\d+)$/ do |expected_code|
  status_code.should == expected_code.to_i
end

