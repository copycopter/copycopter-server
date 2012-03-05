When 'I save and open the page' do
  save_and_open_page
end

Then /^show me the sent emails?$/ do
  pretty_emails = ActionMailer::Base.deliveries.map do |mail|
    <<-OUT.strip_heredoc
      To: #{mail.to.inspect}
      From: #{mail.from.inspect}
      Subject: #{mail.subject}
      Body:
      #{mail.body}
      .
    OUT
  end

  puts pretty_emails.join('\n')
end
