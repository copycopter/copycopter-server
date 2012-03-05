Feature: Blurb Browsing

  @javascript
  Scenario: Listing Blurbs in a Project
    Given a project exists with a name of "Project 1"
    And the following copy exists:
      | project   | draft content                      | key      |
      | Project 1 | blah la                            | test.key |
      | Project 1 | blah ha                            | awesome! |
      | Project 1 | this is a very long bunch of words | more.key |
      | Project 1 | Some simple text                   | another  |
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

