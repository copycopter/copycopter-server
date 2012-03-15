Feature: Download blurbs for a project through API

  Scenario: download draft blurbs for a known project
    Given a project exists with a name of "Breakfast"
    When I POST the v2 API URI for "Breakfast" draft blurbs:
      | en.test.one | expected one |
      | en.test.two | expected two |
    And I GET the v2 API URI for "Breakfast" draft blurbs
    Then I should receive a HTTP 200
    And I should receive the following as a JSON object:
      | en.test.one | expected one |
      | en.test.two | expected two |

  Scenario: download published blurbs for a known project
    Given a project exists with a name of "Breakfast"
    When I POST the v2 API URI for "Breakfast" draft blurbs:
      | en.test.one | expected one |
      | en.test.two | expected two |
    And I POST the v2 API URI for "Breakfast" deploys
    And I make the following revisions:
      | en.test.one | unexpected one |
      | en.test.two | unexpected two |
    When I GET the v2 API URI for "Breakfast" published blurbs
    Then I should receive a HTTP 200
    And I should receive the following as a JSON object:
      | en.test.one | expected one |
      | en.test.two | expected two |

  Scenario: attempt to download draft blurbs for an unknown project
    When I GET the v2 API URL for an unknown project's draft blurbs
    Then I should receive a HTTP 404
    And I should receive the following as a JSON object:
      | error | No project was found with the given API key. |

  Scenario: attempt to download published blurbs for an unknown project
    When I GET the v2 API URL for an unknown project's published blurbs
    Then I should receive a HTTP 404
    And I should receive the following as a JSON object:
      | error | No project was found with the given API key. |

  Scenario: send not modified responses
    Given a project exists with a name of "Breakfast"
    When I POST the v2 API URI for "Breakfast" draft blurbs:
      | en.test.one | expected one |
    And I GET the v2 API URI for "Breakfast" draft blurbs
    Then I should receive a HTTP 200
    And I should receive the following as a JSON object:
      | en.test.one | expected one |
    When I GET the v2 API URI for "Breakfast" draft blurbs
    Then I should receive a HTTP 304
    When I make the following revisions:
      | en.test.one | update |
    And I GET the v2 API URI for "Breakfast" draft blurbs
    Then I should receive the following as a JSON object:
      | en.test.one | update |

  Scenario: download published blurbs with a json hieratchy for a known project
    Given a project exists with a name of "Breakfast"
    When I POST the v2 API URI for "Breakfast" draft blurbs:
      | en.test.one | expected one |
      | en.test.two | expected two |
    And I POST the v2 API URI for "Breakfast" deploys
    When I GET the v2 API URI for "Breakfast" published blurbs with a hierarchy param
    Then I should receive a HTTP 200
    And I should receive the following JSON response:
    """
      {
        "en": {
          "test": {
            "one": "expected one",
            "two": "expected two"
          }
        }
      }
    """

  Scenario: download draft blurbs with a json hierarchy for a known project 
    Given a project exists with a name of "Breakfast"
    When I POST the v2 API URI for "Breakfast" draft blurbs:
      | en.test.one | expected one |
      | en.test.two | expected two |
    And I GET the v2 API URI for "Breakfast" draft blurbs with a hierarchy param
    Then I should receive a HTTP 200
    And I should receive the following JSON response:
    """
      {
        "en": {
          "test": {
            "one": "expected one",
            "two": "expected two"
          }
        }
      }
    """
