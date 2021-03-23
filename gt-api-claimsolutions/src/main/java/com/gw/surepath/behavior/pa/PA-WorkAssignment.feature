@personal_auto @fnol
Feature: Work Assignment

  Background:
    Given I am a user with the "Adjuster" role

  @DesignatedFunction
  Scenario: Assign a High-complexity claim
    Given a Personal Auto policy
    And a draft claim
    And for an insured's vehicle
    And the vehicle is total loss
    And I create an exposure for the vehicle
    And the loss location is in:
      | city      | state |
      | San Mateo | CA    |
    When the claim is submitted
    Then the claim was assigned to the "Auto1 - TeamA"

  @DesignatedFunction
  Scenario: Assign a Mid-complexity claim
    Given a Personal Auto policy
    And a draft claim
    And for an insured's vehicle
    And I create an exposure for the vehicle
    And the loss location is in:
      | city      | state |
      | San Mateo | CA    |
    When the claim is submitted
    Then the claim was assigned to the "Auto1 - TeamB"

  @DesignatedFunction
  Scenario: Exposure Assignment
    Given a Personal Auto policy
    And a draft claim
    And for an insured's vehicle
    And I create an exposure for the vehicle
    When the claim is submitted
    Then the exposure is assigned to the claim owner