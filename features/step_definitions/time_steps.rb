Given /^today is "([^\"]*)"$/ do |date|
  date = Date.parse(date)
  Timecop.travel date
end

When /^a week goes by$/ do
  Timecop.travel 1.week.from_now
end

After { Timecop.return }

When /^I wait (\d+) seconds$/ do |seconds|
  sleep seconds.to_i
end
