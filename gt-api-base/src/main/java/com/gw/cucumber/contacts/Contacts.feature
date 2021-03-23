Feature: Contacts
  As an adjuster I want to perform actions on claim contacts

  Background:
    * def username = testDataContainer.getUser("ccadjuster1").getName()
    * def password = 'gw'
    * configure headers = read('classpath:headers.js')
    * def claimsUrl = ccBaseUrl + '/rest/claim/v1/claims'

  @id=CreateNewContact
  Scenario: I add a {string} contact to the claim with first name {string} and last name {string}
    * def parameters = ["contactSubtype", "fistName", "lastName"]
    * def createNewContactTemplate = 'classpath:com/gw/cucumber/contacts/CreateNewContact.json'
    * def createContactUrl = claimsUrl + "/" + __arg.cucumberDataCache.claimId + '/contacts'
    Given url createContactUrl
    And request readWithArgs(createNewContactTemplate, __arg)
    When method POST
    Then status 201
    And match response.data.attributes.lastName == __arg.parameters.lastName
    And setStepVariable('contactId', response.data.attributes.id)
    And setStepVariable('contactLastName', response.data.attributes.lastName)

  @id=UpdateContactLastName
  Scenario: I update the claim contact last name to be {string}
    * def parameters = ['lastName']
    * def updateContactTemplate = 'classpath:com/gw/cucumber/contacts/UpdateContact.json'
    * def updateContactUrl = claimsUrl + "/" + __arg.cucumberDataCache.claimId + '/contacts/' + __arg.cucumberDataCache.contactId
    * def requestPayload = readWithArgs(updateContactTemplate, __arg)
    Given url updateContactUrl
    And request requestPayload
    When method PATCH
    Then status 200
    * match response.data.attributes.lastName == requestPayload.data.attributes.lastName

  @id=GetContact
  Scenario: the claim Person contact last name is {string}
    * def parameters = ['lastName']
    * def getContactUrl = claimsUrl + "/" + __arg.cucumberDataCache.claimId + '/contacts/' + __arg.cucumberDataCache.contactId
    Given url getContactUrl
    When method GET
    Then status 200
    * match response.data.attributes.lastName == __arg.parameters.lastName
