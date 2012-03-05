Feature: Blurb Editing

  As a user
  I want to edit the text in my application
  So that it can be what I want it to be

  Background:
    Given a project exists with a name of "Project 1"

  Scenario: Editing Blurb in a Project
    Given the following copy exists:
      | project   | draft content | key      |
      | Project 1 | blah la       | test.key |
    When I go to the edit blurb page for "test.key" on "Project 1"
    Then I should see "blah la"
    When I fill in "Content" with "new copy"
    And I press "Save Blurb"
    Then I should see "Draft saved."
    And the "Content" field should contain "new copy"
    When I go to the edit blurb page for "test.key" on "Project 1"
    Then I should see "new copy"

  Scenario: Edit a blurb and navigate back to the project
    Given the following copy exists:
      | project   | key      |
      | Project 1 | test.key |
    When I go to the edit blurb page for "test.key" on "Project 1"
    And I follow "Project 1"
    Then I should see "Project 1"

  Scenario: Deleting Blurb in a Project
    Given the following copy exists:
      | project         | draft content | key      |
      | Project 1 | blah la       | test.key |
    When I go to the edit blurb page for "test.key" on "Project 1"
    And I follow "Remove blurb"
    Then I should not see "test.key"

  Scenario: View a project with no blurbs
    When I go to the dashboard page
    And I follow "Project 1"
    Then I should see "Setting up your Rails app"
    And I should see "Adding blurbs to your app"
    But I should not see "Search blurbs"

  Scenario: View a project with blurbs
    Given the following copy exists:
      | project   |
      | Project 1 |
    When I go to the dashboard page
    Then I should not see "Setting up your Rails app"
    And I should not see "Adding blurbs to your app"

  @javascript
  Scenario: Apply formatting to blurbs
    Given the following copy exists:
      | project   | key      | draft content |
      | Project 1 | test.key | <p>hello</p>  |
    When I go to the edit blurb page for "test.key" on "Project 1"
    And I apply the "bold" editor function to "ell"
    And I apply the "italic" editor function to "el"
    And I press "Save Blurb"
    And I go to the blurbs index for the "Project 1" project
    Then I should see "<p>h<b><i>el</i>l</b>o</p>"

  @javascript
  Scenario: Edit blurbs using HTML
    Given the following copy exists:
      | project   | key      | draft content |
      | Project 1 | test.key | <p>hello</p>  |
    When I go to the edit blurb page for "test.key" on "Project 1"
    And I apply the "bold" editor function to "ell"
    And I follow "Edit as HTML"
    Then the "Content" field should contain "<p>h<b>ell</b>o</p>"
    And no visible elements should contain "Edit as HTML"
    And no visible elements should contain "bold"
    When I fill in "Content" with "<p>h<i>ell</i>o</p>"
    And I press "Save Blurb"
    And I go to the blurbs index for the "Project 1" project
    Then I should see "<p>h<i>ell</i>o</p>"

  @javascript
  Scenario: Switch between HTML and simple editing
    Given the following copy exists:
      | project   | key      | draft content |
      | Project 1 | test.key | <p>hello</p>  |
    When I go to the edit blurb page for "test.key" on "Project 1"
    And I apply the "bold" editor function to "ell"
    And I follow "Edit as HTML"
    And I fill in "Content" with "<p>h<i>ell</i>o</p>"
    And I follow "Edit in simple mode"
    Then the editor should contain "<p>h<i>ell</i>o</p>"
    And no visible elements should contain "Edit in simple mode"
    When I apply the "bold" editor function to "ll"
    And I press "Save Blurb"
    And I go to the blurbs index for the "Project 1" project
    Then I should see "<p>h<i>e<b>ll</b></i>o</p>"

  @javascript
  Scenario: Strip extra paragraph tags in simple editing
    Given the following copy exists:
      | project   | key      | draft content |
      | Project 1 | test.key | hello         |
    When I go to the edit blurb page for "test.key" on "Project 1"
    And I apply the "bold" editor function to "ell"
    And I press "Save Blurb"
    And I go to the blurbs index for the "Project 1" project
    Then I should see "h<b>ell</b>o"
    But I should not see "<p>h<b>ell</b>o</p>"

  @javascript
  Scenario: Insert newlines into an inline segment
    Given the following copy exists:
      | project   | key      | draft content |
      | Project 1 | test.key | hello         |
    When I go to the edit blurb page for "test.key" on "Project 1"
    And I add a newline after "ell" in the editor
    And I press "Save Blurb"
    And I go to the blurbs index for the "Project 1" project
    Then I should see "hell<br />o"

  @javascript
  Scenario: Remember editor mode
    Given the following copy exists:
      | project   | key      |
      | Project 1 | test.key |
    When I go to the edit blurb page for "test.key" on "Project 1"
    And I follow "Edit as HTML"
    And I press "Save Blurb"
    Then no visible elements should contain "Edit HTML"
    When I follow "Edit in simple mode"
    And I press "Save Blurb"
    Then no visible elements should contain "Edit in simple mode"

