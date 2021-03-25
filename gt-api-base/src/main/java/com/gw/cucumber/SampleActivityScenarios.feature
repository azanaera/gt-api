Feature: Exposures
  As an adjuster I want to perform actions on claim exposures

  Background:
    Given I create admin data using Test APIs

  Scenario Outline: Verify Claim Activity Creation
    Given a "PersonalAuto" policy
    When I create a claim against that "PersonalAuto" policy
    And I submit the claim
    And I add an activity with "<ActivityPattern>" Activity Pattern and "<Subject>" Subject on that claim
    Then the activity with the "<ActivityPattern>" Activity Pattern and "<Subject>" Subject should exist on that claim

    Examples:
      | ActivityPattern | Subject |
      | coverage | Test |
