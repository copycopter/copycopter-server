module HttpMethods
  %w(get post put delete).each do |verb|
    define_method(verb) { |*args| page.driver.send(verb, *args) }
  end

  def status_code
    page.driver.status_code.to_i
  end

  def response_body
    page.body
  end
end

World HttpMethods
