@javascript
Feature: View instructions for new locale

  Scenario: View instructions for new locale
    Given a project exists with a name of "Project 1"
    And the following localizations exist in the "Project 1" project:
      | draft_content | key | locale |
      | hello         | one | en     |
    When I go to the home page
    And I follow "Project 1"
    And I follow "Add a new locale..."
    Then I should see "Adding new locales to Copycopter"
