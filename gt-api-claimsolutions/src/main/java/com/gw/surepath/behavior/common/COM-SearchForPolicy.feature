@personal_auto @search_policy
Feature: Search for a Policy

  Background:
    Given I am a user with the "Adjuster" role

  @DesignatedFunction
  Scenario Outline: Search for a Personal Auto policy
    Given I know the "<Policy Information>" for a Personal Auto policy
    When I search for the policy
    Then I could find the policy
    Examples:
      | Policy Information |
      | Policy Number      |
      | Policy Type        |
      | State              |
      | ZIP Code           |
