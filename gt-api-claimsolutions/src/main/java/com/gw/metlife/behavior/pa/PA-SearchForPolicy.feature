@personal_auto @search_policy
Feature: Search for a Policy

  Background:
    Given I am a user with the "Adjuster" role

  @DesignatedFunction
  Scenario: Search for a Personal Auto policy
    Given I know the "Policy Number" for a Personal Auto policy
    When I search for the policy
    Then I could find the policy

