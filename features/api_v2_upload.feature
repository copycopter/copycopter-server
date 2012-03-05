Feature: upload default copy using the v2 api

  Scenario: upload default copy for a known project
    Given a project exists with a name of "Breakfast"
    And the following copy exists:
      | project   | draft content | published content | key      |
      | Breakfast | draft one     | published one     | test.one |
      | Breakfast | draft two     | published two     | test.two |
    When I POST the v2 API URI for "Breakfast" draft blurbs:
      | en.test.one   | new one   |
      | en.test.three | new three |
    Then I should receive a HTTP 201
    And the following copy should exist in the "Breakfast" project:
      | draft_content | published_content | key        |
      | draft one     | published one     | test.one   |
      | draft two     | published two     | test.two   |
      | new three     |                   | test.three |

  @allow-rescue
  Scenario: attempt to upload default copy for an unknown project
    When I POST the v2 API URI for an unknown project's draft blurbs
    Then I should receive a HTTP 404
    And I should receive the following as a JSON object:
      | error | No project was found with the given API key. |

  Scenario: attempt to upload default copy for a blank key
    Given a project exists with a name of "Breakfast"
    When I POST the v2 API URI for "Breakfast" draft blurbs:
      | en.test.one | not blank |
      |             | blank     |
    Then I should receive a HTTP 201
    And the following copy should exist in the "Breakfast" project:
      | draft_content | published_content | key      |
      | not blank     |                   | test.one |
    And no blank copy without a key should exist

  Scenario: upload and redownload default copy for several locales
    Given a project exists with a name of "Breakfast"
    When I POST the v2 API URI for "Breakfast" draft blurbs:
      | en.test.one | one |
      | es.test.one | uno |
      | en.test.two | two |
    Then I should receive a HTTP 201
    When I GET the v2 API URI for "Breakfast" draft blurbs
    Then I should receive a HTTP 200
    And I should receive the following as a JSON object:
      | en.test.one | one |
      | es.test.one | uno |
      | en.test.two | two |
      | es.test.two | two |
