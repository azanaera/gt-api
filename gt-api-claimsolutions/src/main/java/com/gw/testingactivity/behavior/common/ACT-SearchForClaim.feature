Feature: SearchClaims

  Background:
    Given I am a user with the "Adjuster" role


  @DesignatedFunction
  Scenario: Search for a claim
    Given a Homeowners policy claim
    When I search for the claim with "Claim Number"
    Then the claim was found using claim number