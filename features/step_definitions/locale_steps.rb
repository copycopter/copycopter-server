Then /^the "([^"]*)" locale should be selected$/ do |locale_key|
  find('#locale_dropdown .selected span').text.should == locale_key
end

