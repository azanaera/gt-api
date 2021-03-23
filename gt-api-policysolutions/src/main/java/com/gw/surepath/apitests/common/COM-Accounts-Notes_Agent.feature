@common
Feature: Account Notes

  As an agent, I want to add or edit notes on an account so I can capture additional information relevant to the account in the system.

  Background:
    Given I am a user with the "Producer" role

  @DesignatedFunction @10200-GW
  Scenario: Create a note on an account
    Given an account exists with the following details:
      | AccountType  | State  |
      | Person       | CA     |
    When I create an account note with the following:
      | Topic      | Subject     | SecurityLevel | Body                                      |
      | prerenewal | Referral    | Unrestricted  | Refer to customer service representative  |
    Then the account should have the following note:
      | Topic      | Subject     | SecurityLevel | Body                                      |
      | prerenewal | Referral    | Unrestricted  | Refer to customer service representative  |