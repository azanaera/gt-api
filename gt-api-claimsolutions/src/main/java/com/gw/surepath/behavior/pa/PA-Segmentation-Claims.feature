@personal_auto @fnol
Feature: Segmentation

  As an adjuster,
  I want the system to be able to categorize the claim segmentation based on exposure's segmentation

  Background:
    Given I am a user with the "Adjuster" role

  #Claim segmentation - no exposure
  @23650-GW
  Scenario: A claim without an exposure is low complexity
    Given a Personal Auto policy
    When I create a claim without an exposure
    And the claim is submitted
    Then the claim is segmented as "Auto - low complexity"

  #Claim segmentation - single exposure
  @23650-GW
  Scenario Outline: A claim with a single exposure has the same complexity as the exposure
    Given a Personal Auto policy
    When I create a draft claim
    And with an "<ExposureSegment>" exposure
    And the claim is submitted
    Then the claim is segmented as "<ClaimSegment>"
    Examples:
      | ExposureSegment        | ClaimSegment           |
      | Auto - low complexity  | Auto - low complexity  |
      | Auto - mid complexity  | Auto - mid complexity  |
      | Auto - high complexity | Auto - high complexity |

  #Claim segmentation - multiple exposures
  @23650-GW
  Scenario Outline: A claim with multiple exposures matches the highest complexity exposure
    Given a Personal Auto policy
    When I create a draft claim
    And with an "<FirstExposureSegment>" first exposure
    And an "<SecondExposureSegment>" second exposure
    And the claim is submitted
    Then the claim is segmented as "<ClaimSegment>"
    Examples:
      | FirstExposureSegment   | SecondExposureSegment  | ClaimSegment           |
      | Auto - low complexity  | Auto - low complexity  | Auto - low complexity  |
      | Auto - mid complexity  | Auto - low complexity  | Auto - mid complexity  |
      | Auto - high complexity | Auto - mid complexity  | Auto - high complexity |