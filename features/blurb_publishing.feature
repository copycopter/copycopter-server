Feature: publish a blurb

  Background:
    Given a project exists with a name of "Testo"

  Scenario: create and publish a draft
    Given the following copy exists:
      | project | key      |
      | Testo   | test.key |
    When I go to the edit blurb page for "test.key" on "Testo"
    And I fill in "Content" with "Final copy"
    And I choose "Publish"
    And I press "Save Blurb"
    Then I should see "Content published. It takes up to 5 minutes for new content to appear on the live site."
    When I go to the edit blurb page for "test.key" on "Testo"
    Then I should see "Final copy"
    And the "Publish" checkbox should be checked

  @javascript
  Scenario: edit a published version
    Given the following copy is published:
      | project | key      | content           |
      | Testo   | test.key | This is published |
    When I go to the edit blurb page for "test.key" on "Testo"
    Then the "Publish" checkbox should be checked
    And a visible element should contain "Published"
    And no visible elements should contain "Draft"
    And a visible element should contain "This text will be displayed in all environments"
    When I change the editor's content to "New copy"
    Then the "Draft" checkbox should be checked
    And no visible elements should contain "Published"
    And a visible element should contain "Draft"
    And a visible element should contain "This text will be displayed in development"
    When I follow "published version"
    Then a visible element should contain "This is published"
    When I choose "Publish"
    Then a visible element should contain "This text will be displayed in all environments"
    When I choose "Draft"
    Then a visible element should contain "This text will be displayed in development"
    When I press "Save Blurb"
    Then I should see "Draft saved."
    When I go to the edit blurb page for "test.key" on "Testo"
    Then a visible element should contain "This text will be displayed in development"
    And no visible elements should contain "Published"
    And a visible element should contain "Draft"
    And I should see "New copy" in the editor
    And the "Draft" checkbox should be checked
    And no visible elements should contain "This is published"
    When I follow "latest published version"
    Then a visible element should contain "This is published"

  @javascript
  Scenario: edit a version that has never been published
    Given the following copy exists:
      | project | key      |
      | Testo   | test.key |
    When I go to the edit blurb page for "test.key" on "Testo"
    Then a visible element should contain "The default text will be displayed in production"
    But no visible elements should contain "latest published version"
    When I choose "Publish"
    Then a visible element should contain "This text will be displayed in all environments"
    When I choose "Draft"
    Then a visible element should contain "The default text will be displayed in production"

