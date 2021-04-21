@personal_auto @fnol
Feature: Segmentation

  As an adjuster,
  I want the system to be able to categorize the exposure's segmentation based on key variables such as complexity, severity, etc...

  Background:
    Given I am a user with the "Adjuster" role

  #Exposure segmentation - insured vehicle occupants with minor injuries
  @23650-GW
  Scenario: Personal Auto claim with insured vehicle occupant with minor injuries exposure segmentation
    Given a Personal Auto policy
    When I create a draft claim
    And with the insured vehicle with a minor injured driver
    And the claim is submitted
    Then the exposure is segmented as "Auto - low complexity"

  #Exposure segmentation - third party vehicles
  @23650-GW
  Scenario: Personal Auto claim with third party vehicle exposure segmentation
    Given a Personal Auto policy
    When I create a draft claim
    And with a third party vehicle
    And the claim is submitted
    Then the exposure is segmented as "Auto - mid complexity"

  #Exposure segmentation - fatally injuries
  @23650-GW
  Scenario: Personal Auto claim with fatally injury exposure segmentation
    Given a Personal Auto policy
    When I create a draft claim
    And with the insured vehicle with a fatally injured driver
    And the claim is submitted
    Then the exposure is segmented as "Auto - high complexity"

  #Exposure segmentation - total loss vehicles
  @23650-GW
  Scenario: Personal Auto claim with total loss vehicle exposure segmentation
    Given a Personal Auto policy
    When I create a draft claim
    And with the insured vehicle being a total loss
    And the claim is submitted
    Then the exposure is segmented as "Auto - high complexity"