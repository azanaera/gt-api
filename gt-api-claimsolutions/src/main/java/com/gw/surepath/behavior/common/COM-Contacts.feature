@common @search_contact
Feature: Contact

  Background:
    Given I am a user with the "Adjuster" role

  @DesignatedFunction
  Scenario Outline: Searching for a Contact
    Given a known person in the global address book
    When I search for that person with their "<identifier>"
    Then the contact was found
    Examples:
      | identifier        |
      | Last Name         |
      | City and State    |
      | Zip Code          |