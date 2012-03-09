Feature: Deploy project through API

  Scenario: Deploy a known project
    Given a project exists with a name of "Breakfast"
    And a project exists with a name of "Other"
    And the following localizations exist in the "Breakfast" project:
      | draft_content | published_content | key        |
      | draft one     | published one     | test.one   |
      | draft two     | published two     | test.two   |
    And the following localizations exist in the "Other" project:
      | draft_content | published_content | key        |
      | other draft   | other published   | test.other |
    When I POST the v2 API URI for "Breakfast" deploys
    Then I should receive a HTTP 201
    And the following blurb should exist in the "Breakfast" project:
      | draft_content | published_content | key      |
      | draft one     | draft one         | test.one |
      | draft two     | draft two         | test.two |
    And the following blurb should exist in the "Other" project:
      | draft_content | published_content | key        |
      | other draft   | other published   | test.other |

  Scenario: Deploy an unknown project
    When I POST the v2 API URI for an unknown project's deploys
    Then I should receive a HTTP 404
    And I should receive the following as a JSON object:
      | error | No project was found with the given API key. |

