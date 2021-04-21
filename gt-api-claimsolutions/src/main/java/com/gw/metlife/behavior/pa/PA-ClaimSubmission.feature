@personal_auto @fnol
Feature: Different types of Claim Submission

  Background:
    Given I am a user with the "Adjuster" role

    @DesignatedFunction
    Scenario: Quick Claim
      Given a Personal Auto policy
      When I create a quick claim
      And is reported by the insured
      And the loss cause was a "Fire"
      And the loss location was the insured's address
      And the claim is submitted
      Then activities are planned:
        | activity                          |
        | Make initial contact with insured |
        | Initial 30 day file review        |

    @DesignatedFunction
    Scenario: Unverified Policy
      Given an unverified Personal Auto policy:
        | effectiveDate | expirationDate  | insuredFirstName  | insuredLastName |
        | Yesterday     | Tomorrow        | Ray               | Newton          |
      When I create a draft claim
      And the loss cause was a "Fire"
      And the loss location is in:
        | city      | state |
        | San Mateo | CA    |
      And the claim is submitted
      Then activities are planned:
        | activity                          |
        | Make initial contact with insured |
        | Initial 30 day file review        |