@personal_auto @search_policy
Feature: Search for a Policy

  Background:
    Given I am a user with the "Adjuster" role

  @DesignatedFunction
  Scenario: Search for a Homeowners policy
    Given I know the "Policy Number" for a Homeowners policy
    When I search for the policy
    Then I could find the policy

