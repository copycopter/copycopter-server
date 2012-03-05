Feature: Blurb Search

  Background:
    Given a project exists with a name of "Project 1"

  @javascript
  Scenario: Filter blurbs by key
    Given the following copy exists:
      | project   | key            |
      | Project 1 | test.find.this |
      | Project 1 | test.Find.that |
      | Project 1 | test.miss.that |
    When I go to the blurbs index for the "Project 1" project
    Then no visible elements should contain "find"
    And a visible element should contain "Type the first"
    And a visible element should contain "View all"
    When I focus the "Search" field
    Then no visible elements should contain "Type the first"
    When I type "find" into "Search"
    Then a visible element should contain "test.find.this"
    And a visible element should contain "test.Find.that"
    But no visible elements should contain "test.miss.this"
    And no visible elements should contain "View all"
    When I type "find that" into "Search"
    Then a visible element should contain "test.Find.that"
    But no visible elements should contain "test.find.this"
    And no visible elements should contain "test.miss.this"
    When I clear the "Search" field
    Then no visible elements should contain "find"
    And a visible element should contain "View all"

  @javascript
  Scenario: Perform a search with no results
    Given the following copy exists:
      | project   | key      |
      | Project 1 | test.key |
    When I go to the blurbs index for the "Project 1" project
    Then no visible elements should contain "No results"
    When I type "find" into "Search"
    Then a visible element should contain "No results"
    When I type "" into "Search"
    Then no visible elements should contain "No results"
    When I type "test" into "Search"
    Then no visible elements should contain "No results"
