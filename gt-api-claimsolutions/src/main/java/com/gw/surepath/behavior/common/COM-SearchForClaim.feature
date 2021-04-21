@common @search_claim
Feature: SearchClaims

  Background:
    Given I am a user with the "Adjuster" role

  @DesignatedFunction
  Scenario Outline: Search for a claim
    Given a Personal Auto claim
    When I search for the claim with the "<Identifier>"
    Then the claim was found
    Examples:
      | Identifier    |
      | Claim Number  |
      | Policy Number |

  @DesignatedFunction
  Scenario: Search for a claim by contacts
    Given a Personal Auto claim
    When I search for the claim with the claim contact information:
      | claimContact       | identifier        |
      | Insured            | First Name        |
      | Any Party Involved | Last Name         |
    Then the claim was found