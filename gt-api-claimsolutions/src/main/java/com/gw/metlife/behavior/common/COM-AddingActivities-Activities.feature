@common @add_activity
Feature: Activity

  Background:
    Given I am a user with the "Adjuster" role

  @DesignatedFunction
  Scenario: Adding an activity manually
    Given a Personal Auto claim
    When I create an activity to "Send claim acknowledgement letter" for the claim
    Then the activity is in the workplan
    And the activity is assigned to the claim owner