@homeowners @fnol
Feature: Different types of Claim Submission

  Background:
    Given I am a user with the "Adjuster" role

    @DesignatedFunction
    Scenario: Quick Claim
      Given a Homeowners policy
      When I create a quick claim
      And the claim is submitted
      Then activities are planned:
        | activity                          |
        | Make initial contact with insured |
        | Initial 30 day file review        |
