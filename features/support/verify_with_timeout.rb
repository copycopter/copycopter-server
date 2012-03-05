module VerifyWithTimeout
  def verify_with_timeout(selector, failure_message)
    Capybara.timeout do
      page.has_css?(selector) && yield(find(selector))
    end
  rescue Capybara::TimeoutError
    if page.has_css?(selector)
      raise failure_message
    else
      raise "Couldn't find #{selector}"
    end
  end
end

World VerifyWithTimeout
