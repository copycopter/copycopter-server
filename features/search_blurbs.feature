Feature: Blurb Search

  Background:
    Given a project exists with a name of "Project 1"

  @javascript
  Scenario: Filter blurbs by key
    Given the following localizations exist in the "Project 1" project:
      | key            |
      | test.find.this |
      | test.Find.that |
      | test.miss.that |
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

  @javascript
  Scenario: Perform a search with no results
    Given the following localizations exist in the "Project 1" project:
      | key      |
      | test.key |
    When I go to the blurbs index for the "Project 1" project
    Then no visible elements should contain "No results"
    When I type "find" into "Search"
    Then a visible element should contain "No results"
    When I clear the "Search" field
    And I type "test" into "Search"
    Then no visible elements should contain "No results"
