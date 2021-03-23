@personal_auto @fnol
Feature: Activities

  Background:
    Given I am a user with the "Adjuster" role

  @DesignatedFunction
  Scenario: Contact Insured
    Given a Personal Auto policy
    When I create a claim
    Then an activity is planned:
      | activity                          |
      | Make initial contact with insured |

  @DesignatedFunction
  Scenario: Vehicle Inspection
    Given a Personal Auto policy
    When I create a claim
    And for an insured's vehicle
    And I create an exposure for the vehicle
    Then an activity is planned:
      | activity              |
      | Get vehicle inspected |
