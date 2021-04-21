@personal_auto @fnol
Feature: Exposures

  Background:
    Given I am a user with the "Adjuster" role

  @DesignatedFunction
  Scenario: Personal Auto - Comprehensive
    Given a Personal Auto policy with comprehensive coverage
    When I create a draft claim
    And the loss cause was a "fire"
    And for an insured's vehicle
    And the claim is submitted
    Then a "Comprehensive" exposure exists