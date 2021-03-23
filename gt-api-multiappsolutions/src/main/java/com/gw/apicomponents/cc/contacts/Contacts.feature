Feature: Contacts
  As an adjuster I want to perform actions on claim contacts

  @id=CreateNewContact #The id tag needs to be defined on new line than that of other tags.
  Scenario: create a new contact
    #Framework validation enforced only for requiredArguments
    * def requiredArguments = ['claimId']
    * def createNewContactTemplate = 'classpath:com/gw/apicomponents/cc/contacts/createNewContact.json'
    * def createContactUrl = claimsUrl + "/" + __arg.scenarioArgs.claimId + '/contacts'
    Given url createContactUrl
    And request read(createNewContactTemplate)
    When method POST
    Then status 201
    And setStepVariable('contactId', response.data.attributes.id)
    * match response.data.attributes.lastName == "Flintstone"

  @id=UpdateContactLastName
  Scenario: Update  contact's last name
    * def requiredArguments = ['claimId','contactId']
    * def updateContactTemplate = 'classpath:com/gw/apicomponents/cc/contacts/updateContact.json'
    * def updateContactUrl = claimsUrl + "/" + __arg.scenarioArgs.claimId + '/contacts/' + __arg.scenarioArgs.contactId
    Given url updateContactUrl
    And request readWithArgs(updateContactTemplate, __arg.templateArgs)
    When method PATCH
    Then status 200
    * match response.data.attributes.lastName == __arg.templateArgs.lastName

  @id=GetContact
  Scenario: get the contact data
    * def requiredArguments = ['claimId','contactId']
    * def getContactUrl = claimsUrl + "/" + __arg.scenarioArgs.claimId + '/contacts/' + __arg.scenarioArgs.contactId
    Given url getContactUrl
    When method GET
    Then status 200
    * match response.data.attributes.lastName == __arg.scenarioArgs.lastName
