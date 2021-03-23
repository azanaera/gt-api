@common @add_note
Feature: Note
  As an adjuster, I want to add a note on a claim, service request and activity.

  Background:
    Given I am a user with the "Adjuster" role

  @23160-GW @DesignatedFunction
  Scenario: Adding a note to a new Personal Auto claim
    Given a Personal Auto policy
    And a draft claim
    Then I can add a note with the following:
      | topic     | body                                     |
      | coverage  | Insured provided details of third party  |

  @23160-GW @DesignatedFunction
  Scenario: Adding a note to an existing Personal Auto claim
    Given a Personal Auto claim
    Then I can add a note with the following:
      | topic     | body                                     |
      | coverage  | Insured provided details of third party  |

  @23160-GW @DesignatedFunction
  Scenario: Adding a note related to a service request of a Personal Auto claim
    Given a Personal Auto claim
    And a service request with the following:
      | request	        | serviceToPerform	| serviceAddress            |
      | Perform Service	| Glass	            | Insured's Primary Address |
    Then I can add a note related to the service request with the following:
      | topic     | body                                                           |
      | coverage  | Repairer performed chip repair in windscreen on passenger side |

  @23160-GW @DesignatedFunction
  Scenario: Adding a note for an activity of a Personal Auto claim
    Given a Personal Auto claim
    And with a planned activity with the following:
      | activity	          | for	  |
      | Get vehicle inspected | Claim |
    Then I can add a note related to the activity with the following:
      | topic     | body                                                           |
      | coverage  | Repairer performed chip repair in windscreen on passenger side |