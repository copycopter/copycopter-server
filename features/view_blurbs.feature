Feature: View blurbs

  @javascript
  Scenario: View blurbs for a project
    Given a project exists with a name of "Project 1"
    And the following localizations exist in the "Project 1" project:
      | draft_content                      | key      |
      | blah la                            | test.key |
      | blah ha                            | awesome! |
      | this is a very long bunch of words | more.key |
      | Some simple text                   | another  |
    When I go to the dashboard page
    And I follow "Project 1"
    Then no visible elements should contain "test"
    When I follow "View all 4 blurbs"
    Then a visible element should contain "test"
    And I should see "awesome!" before "test.key"
    And I should see "blah la"
    And I should see "this is a very long bunch of words"
    And no visible elements should contain "View all"
    When I fill in "Search" with "anything"
    And I clear the "Search" field
    Then a visible element should contain "View all"

