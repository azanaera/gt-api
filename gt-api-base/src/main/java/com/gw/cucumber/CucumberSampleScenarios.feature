Feature: This feature contains a set of sample cucumber scenarios whose steps call and execute GT API re-usable scenarios.
  1. It demonstrates how cucumber steps call GT API re-usable scenarios
  2. It also contains some sample use cases of cucumber scenario outlines, examples and step data tables
  For more complete understanding, it might be considered with its set of associated GT API scenarios
  in the same package as this feature file.
  (Reference claimsolutions GT API scenario: RunCreateUpdateGetContactNoteAndExposure.feature)

  Background:
    Given I create admin data using Test APIs

  @CucumberSample
  Scenario: Cucumber scenario
    Given a "PersonalAuto" policy
    When I create a claim against that "PersonalAuto" policy
    And I submit the claim
    And I create a vehicle incident with damage description "Broken windshield"
    And I add a "Person" contact to the claim with first name "John" and last name "Doe"
    And I create an exposure on the claim vehicle incident
    And I add a "public" note with body "Create Note on Personal Auto claim" and subject "Test Note on CA" and topic "general" to the claim
    And I update the claim contact last name to be "Tester"
    And I update the claim exposure jurisdiction to be "CA"
    And I update the claim note to be "confidential" and its subject to be "Test Update Note on CA" and its topic to be "coverage"
    Then I find the claim
    And the claim vehicle incident damage description is "Broken windshield"
    And the claim exposure jurisdiction is "CA"
    And the claim note is "confidential" and its subject is "Test Update Note on CA" and its topic is "coverage"
    When I close the claim activities
    And I close the claim exposure
    Then I close the claim


  @CucumberSample
  Scenario: Cucumber scenario with step data tables and step iteration
    Given a "PersonalAuto" policy
    When I create a claim against that "PersonalAuto" policy
    And I submit the claim
    And I create a vehicle incident with damage description "Broken windshield":
      |vin                |make      |model|year|licensePlate|state|color|
      |75756839393HTDDCSl5|Oldsmobile|442  |1968|465TF67J    |NY  |Blue |
    And I create some vehicle incidents:
      |damageDescription |vin                |make      |model|year|licensePlate|state|color|
      | Damaged hood     |75756839393HTDDCSl5|Oldsmobile|442  |1968|465TF67J    |NY  |Blue  |
      | Broken Mirror    |75756839393HTDDCSl5|Oldsmobile|442  |1968|465TF67J    |NY  |Blue  |
    And I add a "Person" contact to the claim with first name "John" and last name "Doe"
    And I create an exposure on the claim vehicle incident
    And I add a "public" note with body "Create Note on Personal Auto claim" and subject "Test Note on CA" and topic "general" to the claim
    And I add "private" notes with body "Private note on claim":
      |subject          |topic  |
      |Private subject 1|general|
      |Private subject 2|general|
    And I update the claim contact last name to be "Tester"
    And I update the claim exposure jurisdiction to be "CA"
    And I update the claim note to be "confidential" and its subject to be "Test Update Note on CA" and its topic to be "coverage"
    Then I find the claim
    And the claim vehicle incident damage description is "Broken windshield":
      |vin                |make      |model|year|licensePlate|state|color|
      |75756839393HTDDCSl5|Oldsmobile|442  |1968|465TF67J    |NY   |Blue |
    And the claim Person contact last name is "Tester"
    And the claim exposure jurisdiction is "CA"
    And the claim note is "confidential" and its subject is "Test Update Note on CA" and its topic is "coverage"
    When I close the claim activities
    And I close the claim exposure
    Then I close the claim


  @CucumberSample
  Scenario Outline: Cucumber scenario outline with examples table
    Given a <lineOfBusiness> policy
    When I create a claim against that "PersonalAuto" policy
    And I submit the claim
    And I create a vehicle incident with damage description "Broken windshield"
    And I add a "Person" contact to the claim with first name "John" and last name "Doe"
    And I create an exposure on the claim vehicle incident
    And I add a "public" note with body "Create Note on Personal Auto claim" and subject "Test Note on CA" and topic "general" to the claim
    And I update the claim contact last name to be "Tester"
    And I update the claim exposure jurisdiction to be "CA"
    And I update the claim note to be "confidential" and its subject to be "Test Update Note on CA" and its topic to be "coverage"
    Then I find the claim
    And the claim vehicle incident damage description is "Broken windshield"
    And the claim exposure jurisdiction is "CA"
    And the claim note is "confidential" and its subject is "Test Update Note on CA" and its topic is "coverage"
    When I close the claim activities
    And I close the claim exposure
    Then I close the claim
    Examples:
      |lineOfBusiness|
      |PersonalAuto  |
      |PersonalAuto  |






