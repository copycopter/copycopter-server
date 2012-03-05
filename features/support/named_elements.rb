module NamedElements
  def selector_for(named_element)
    case named_element
    when /inline error messages/
      '.error'
    when /(?:an |)error messages?/
      '#errorExplanation'
    when /blurb search form/
      '#blurb_search'
    when /the "([^"]+)" editor button/
      ".wysiwyg .toolbar li:contains('#{$1}')"
    when /^the "([^"]+)" plan options$/
      ".plan.#{$1.downcase}"
    when /^the "([^"]+)" plan$/
      "#plans-#{$1.downcase} a"
    when /locale dropdown/
      '#locale_dropdown .menu'
    else
      raise "Add #{named_element} to features/support/named_elements.rb."
    end
  end
end

World NamedElements
