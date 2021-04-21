Feature: Contact
  Action scenarios that operate on Contacts

  Background:
    * def username = __arg.scenarioArgs.username
    * def password = claimsDataContainer.getPassword()
    * def contactsUrl = ccBaseUrl + '/rest/testsupport/v1/contacts'
    * def claimsUrl = ccBaseUrl + '/rest/claim/v1/claims'
    * configure headers = read('classpath:headers.js')
    * def sharedPath = 'classpath:com/gw/surepath/action/contact/'

  @id=GetInsuredPrimaryAddress
  Scenario: Get insured's primary address
    * def requiredArguments = ['claimId', 'insuredId']
    * def getContactUrl = claimsUrl + "/" + __arg.scenarioArgs.claimId + "/contacts/" + __arg.scenarioArgs.insuredId
    Given url getContactUrl
    When method GET
    Then status 200
    * setStepVariable('primaryAddress', response.data.attributes.primaryAddress)

  @id=CreateThirdPartyContact
  Scenario: Create a third party contact
    * def requiredArguments = ['claimId']
    * def createNewContactTemplate = sharedPath + 'createThirdPartyContact.json'
    * def createContactUrl = claimsUrl + "/" + __arg.scenarioArgs.claimId + '/contacts'
    Given url createContactUrl
    And request read(createNewContactTemplate)
    When method POST
    Then status 201
    And setStepVariable('thirdPartyContactId', response.data.attributes.id)

  @id=SearchContact
  Scenario: Search Contact
    * def requiredArguments = ['contactInformation']
    * def getContactSearchTemplate =
    """
      function(contactInformation) {
        switch(contactInformation) {
          case 'Last Name':
            return sharedPath + 'searchContactByLastName.json'
          case 'City and State':
            return sharedPath + 'searchContactByCityState.json'
          case 'Zip Code':
            return sharedPath + 'searchContactByZipCode.json'
        }
       }
    """
    * def searchContactTemplate = getContactSearchTemplate(__arg.scenarioArgs.contactInformation)
    * def searchContactUrl = ccBaseUrl + '/rest/testsupport/v1/search/contacts'
    Given url searchContactUrl
    And request readWithArgs(searchContactTemplate, __arg.templateArgs)
    When method POST
    Then status 200
    * assert response.count > 0
    * def listOfContactIds = karate.jsonPath(response, '$.data[*].attributes.addressBookUID')
    * setStepVariable('listOfContactIds', listOfContactIds)

  @id=MatchContactByContactId
  Scenario: Match a contact by contact ID
    * def requiredArguments = ['listOfContactIds', 'contactId']
    * match __arg.scenarioArgs.listOfContactIds contains __arg.scenarioArgs.contactId