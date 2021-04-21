@personal_auto @fnol
Feature: Service Request

  Background:
    Given I am a user with the "Adjuster" role

  @DesignatedFunction
  Scenario: A service request is created during FNOL for a new claim to "Quote and Perform Service" for "Auto Body"
    Given a Personal Auto policy
    When I create a draft claim
    And for an insured's vehicle
    And I request a "Quote and Perform Service" for "Auto body"
    And the claim is submitted
    Then a "Auto body" service of type "Quote and Perform Service" should be requested on the claim