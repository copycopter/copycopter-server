Feature: Upload default blurb for a project through API

  Scenario: Upload default blurb for a known project
    Given a project exists with a name of "Breakfast"
    And the following localizations exist in the "Breakfast" project:
      | draft_content | published_content | key      |
      | draft one     | published one     | test.one |
      | draft two     | published two     | test.two |
    When I POST the v2 API URI for "Breakfast" draft blurbs:
      | en.test.one   | new one   |
      | en.test.three | new three |
    Then I should receive a HTTP 201
    And the following blurb should exist in the "Breakfast" project:
      | draft_content | published_content | key        |
      | draft one     | published one     | test.one   |
      | draft two     | published two     | test.two   |
      | new three     |                   | test.three |

  Scenario: Try to upload default blurb for an unknown project
    When I POST the v2 API URI for an unknown project's draft blurbs
    Then I should receive a HTTP 404
    And I should receive the following as a JSON object:
      | error | No project was found with the given API key. |

  Scenario: Try to upload default blurb for a blank key
    Given a project exists with a name of "Breakfast"
    When I POST the v2 API URI for "Breakfast" draft blurbs:
      | en.test.one | not blank |
      |             | blank     |
    Then I should receive a HTTP 201
    And the following blurb should exist in the "Breakfast" project:
      | draft_content | published_content | key      |
      | not blank     |                   | test.one |
    And no blank blurb without a key should exist

  Scenario: Download default blurb for several locales
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
