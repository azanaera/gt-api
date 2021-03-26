Feature: CC Designated Functions
  As a ClaimCenter user, I want to perform different functionality on a claim

  Background:
    Given I create admin data using Test APIs

  Scenario Outline: Searching for a Claim
    Given I search claims with following inputs "<LastName>" "<Code>"
    Examples:
      | LastName | Code    |
     | Portman | insured  |
     | Portman | insured  |