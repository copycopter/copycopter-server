Then /^no blank blurb without a key should exist$/ do
  Blurb.where(key: '').count.should == 0
end
