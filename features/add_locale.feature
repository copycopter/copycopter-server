@javascript
Feature: See help for adding a new locale

  Scenario: view blurbs in a particular locale
    Given a project exists with a name of "Project 1"
    And the following copy exists:
      | project   | draft content | key | locale |
      | Project 1 | hello         | one | en     |
    When I go to the dashboard page
    And I follow "Project 1"
    And I follow "Add a new locale..."
    Then I should see "Adding new locales to Copycopter"
