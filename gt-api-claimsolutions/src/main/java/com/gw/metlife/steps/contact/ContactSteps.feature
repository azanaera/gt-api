Feature: Contact
  Step scenarios that operate on Contacts

  Background:
    * def username = claimUtils.getUnrestrictedUser()

  @id=KnownPersonInAddressBook
  Scenario: a known person in the global address book
    * __arg.cucumberDataCache.contactSearchId = "ab:68"
    * __arg.cucumberDataCache.contactSearchLastName = "Andrews"
    * __arg.cucumberDataCache.contactSearchCity = "San Francisco"
    * __arg.cucumberDataCache.contactSearchState = "CA"
    * __arg.cucumberDataCache.contactSearchZipCode = "94104"

  @id=SearchPersonWithCriteria
  Scenario: I search for that person with their {string}
    * def parameters = ['contactInformation']
    When step('ContactActions.SearchContact', {'scenarioArgs': {'username': username, 'contactInformation': __arg.parameters.contactInformation}, 'templateArgs': __arg.cucumberDataCache})
    * __arg.cucumberDataCache.listOfContactIds = getStepVariable('ContactActions.SearchContact', 'listOfContactIds')

  @id=TheContactFound
  Scenario: the contact was found
    When step('ContactActions.MatchContactByContactId', {'scenarioArgs': {'listOfContactIds': __arg.cucumberDataCache.listOfContactIds, 'contactId': __arg.cucumberDataCache.contactSearchId}})
