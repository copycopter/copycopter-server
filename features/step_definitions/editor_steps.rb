module EditorHelpers
  def within_editor
    find 'iframe'
    within_frame(0) { yield }
  end
end

World EditorHelpers

When /^I unfocus the editor$/ do
  page.execute_script(%{
    parent.focus();
  })
end

Then /^I should see "([^"]*)" in the editor$/ do |text|
  within_editor do
    page.should have_content(text)
  end
end

When /^I select "([^"]+)" from the editor$/ do |text|
  within_editor do
    page.execute_script <<-JS
      var xpath = "//*/child::text()[contains(., '#{text}')]";
      var node = document.evaluate(xpath, document, null, XPathResult. ANY_UNORDERED_NODE_TYPE, null).singleNodeValue;
      if (!node)
        throw("Couldn't find text to select");
      var start = node.data.indexOf('#{text}');
      var end = start + #{text.size};
      var selection = window.getSelection();
      var range = window.document.createRange();
      range.setStart(node, start);
      range.setEnd(node, end);
      selection.removeAllRanges();
      selection.addRange(range);
    JS
  end
end

When /^I change the editor's content to "([^"]*)"$/ do |content|
  page.execute_script %{
    $('#version_content').wysiwyg("setContent", "#{content}");
    $($('#version_content').data("wysiwyg").editorDoc).trigger("keyup");
  }
end

When /^I apply the "([^"]+)" editor function to "([^"]+)"$/ do |function, selection|
  steps %{
    When I select "#{selection}" from the editor
    And I click the "#{function}" editor button
    And I unfocus the editor
  }
end

Then /^the editor should contain "([^"]*)"$/ do |content|
  page.evaluate_script(%{
    $('#version_content').wysiwyg('getContent')
  }).should == content
end

When /^I add a newline after "([^"]*)" in the editor$/ do |text|
  editor_content = find_field('Content').value
  editor_content = "<p>#{editor_content}</p>" unless editor_content.include?('<p>')
  editor_content.sub!(text, "#{text}</p><p>")
  When %{I change the editor's content to "#{editor_content}"}
end
