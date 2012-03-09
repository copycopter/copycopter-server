@javascript
Feature: translate blurbs

  Background:
    Given a project exists with a name of "Project 1"
    And the following localizations exist in the "Project 1" project:
      | draft_content | key | locale |
      | hello         | one | en     |
      | hola          | one | es     |
      | goodbye       | two | en     |
      | adios         | two | es     |
    When I go to the dashboard page
    And I follow "Project 1"

  Scenario: view blurbs in a particular locale
    Then I should see "hello"
    And I should see "goodbye"
    But I should not see "hola"
    And I should not see "adios"
    When I follow "en"
    And I follow "es"
    Then I should see "hola"
    And I should see "adios"
    But I should not see "hello"
    And I should not see "goodbye"

  Scenario: blurb dropdown on the index
    Then the "en" locale should be selected
    And the locale dropdown should not be visible
    When I follow "Locale: en"
    Then the locale dropdown should be visible
    When I follow "es"
    Then the "es" locale should be selected
    And the locale dropdown should not be visible

  Scenario: blurb dropdown on the edit page
    When I follow "View all"
    And I follow "one"
    Then the "Content" field should contain "hello"
    When I follow "Locale: en"
    And I follow "es"
    Then the "Content" field should contain "hola"
