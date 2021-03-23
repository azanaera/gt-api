Feature: Accounts
  To create and manage an account

  Background:
    * def username = policyusername
    * def password = policypassword
    * def accountsUrl = pcBaseUrl + '/rest/account/v1/accounts'
    * def policyPath = 'classpath:com/gw/apicomponents/pc/policy/'
    * def accountPath = 'classpath:com/gw/apicomponents/pc/account/'
    * configure headers = read('classpath:headers.js')
  @id=AddCompany
  Scenario:  I create a new company account
    #Declarations
    #Scenario
    * def requestPayload = readWithArgs(accountPath + 'addCompany.json', __arg.templateArgs)
    Given url accountsUrl
    And request requestPayload
    When method POST
    Then status 201
    #Verification
    And match response.data.attributes.producerCodes[*].id contains requestPayload.data.attributes.producerCodes[0].id
    And match response.data.attributes.accountHolder.displayName == requestPayload.included.AccountContact[0].attributes.companyName
    * setStepVariable('holderId', response.data.attributes.accountHolder.id)
    * setStepVariable('holderDisplayName', response.data.attributes.accountHolder.displayName)
    * setStepVariable('id', response.data.attributes.id)
    * setStepVariable('producerCodeId', requestPayload.data.attributes.producerCodes[0].id)
    * setStepVariable('addressLine1', requestPayload.included.AccountContact[0].attributes.primaryAddress.addressLine1)
    * setStepVariable('city', requestPayload.included.AccountContact[0].attributes.primaryAddress.city)
    * setStepVariable('postalCode', requestPayload.included.AccountContact[0].attributes.primaryAddress.postalCode)
    * setStepVariable('stateCode', requestPayload.included.AccountLocation[0].attributes.state.code)
    * setStepVariable('accountNumber', response.data.attributes.accountNumber)

  @id=GetAccountActivity
  Scenario:  I retrieve account activity
    * def requiredScenarioArguments = ['accountId']
    * def accountActivitiesUrl = accountsUrl +  "/" + __arg.scenarioArgs.accountId + '/activities'
    * def emptyRequestTemplate = policyPath + 'emptyRequest.json'
    Given url accountActivitiesUrl
    When method GET
    Then status 200
    * setStepVariable('typeCode', response.data[0].attributes.activityType.code)
    * setStepVariable('typeName', response.data[0].attributes.activityType.name)
    * setStepVariable('assignedByUserName', response.data[0].attributes.assignedByUser.displayname)
    * setStepVariable('assignedByUserId', response.data[0].attributes.assignedByUser.id)
    * setStepVariable('assignedGroupName', response.data[0].attributes.assignedGroup.displayname)
    * setStepVariable('assignedGroupId', response.data[0].attributes.assignedGroup.id)
    * setStepVariable('assignedUserName', response.data[0].attributes.assignedUser.displayname)
    * setStepVariable('assignedUserId', response.data[0].attributes.assignedUser.id)
    * setStepVariable('assignmentStatusCode', response.data[0].attributes.assignmentStatus.code)
    * setStepVariable('assignmentStatusName', response.data[0].attributes.assignmentStatus.name)
    * setStepVariable('dueDate', response.data[0].attributes.dueDate)
    * setStepVariable('escalated', response.data[0].attributes.escalated)
    * setStepVariable('escalationDate', response.data[0].attributes.escalationDate)
    * setStepVariable('externallyOwned', response.data[0].attributes.externallyOwned)
    * setStepVariable('id', response.data[0].attributes.id)
    * setStepVariable('mandatory', response.data[0].attributes.mandatory)
    * setStepVariable('priorityCode', response.data[0].attributes.priority.code)
    * setStepVariable('priorityName', response.data[0].attributes.priority.name)
    * setStepVariable('recurring', response.data[0].attributes.recurring)
    * setStepVariable('statusCode', response.data[0].attributes.status.code)
    * setStepVariable('statusName', response.data[0].attributes.status.name)
    * setStepVariable('subject', response.data[0].attributes.subject)

  @id=ProducerAddCompany
  Scenario:  Producer creates a new company account
    * def addAccountUrl = readWithArgs(accountPath + 'producerAddCompany.json', __arg.templateArgs)
    Given url accountsUrl
    And request addAccountUrl
    When method POST
    Then status 201
    * setStepVariable('id', response.data.attributes.id)

  @id=ValidateAccountRetrieved
  Scenario:  Validate an account can be retrieved
    * def requiredScenarioArguments = ['accountId']
    * def accountsUrl = accountsUrl +  "/" + __arg.scenarioArgs.accountId
    Given url accountsUrl
    When method GET
    Then status 200

  @id=ValidateAccountPermissions
  Scenario: Validate Account Permissions
    * def requiredArguments = ['username','accountId','userMessage']
    * def username = __arg.scenarioArgs.username
    * def getAccountsUrl = accountsUrl +  "/" + __arg.scenarioArgs.accountId
    Given url getAccountsUrl
    When method GET
    Then status 404
    And match response.userMessage == __arg.scenarioArgs.userMessage

  @id=GetAccountContact
  Scenario:  Get an account contact
    * def requiredScenarioArguments = ['accountId']
    * def accountsContactsUrl = accountsUrl +  "/" + __arg.scenarioArgs.accountId + '/contacts'
    * def emptyRequestTemplate = policyPath + 'emptyRequest.json'
    Given url accountsContactsUrl
    And request read(emptyRequestTemplate)
    When method GET
    Then status 200
    And setStepVariable('contactId', response.data[0].attributes.id)

  @id=AddPerson
  Scenario:  I create a new person account
    #Declarations
    #Scenario
    * def requestPayload = readWithArgs(accountPath + 'addPerson.json', __arg.templateArgs)
    Given url accountsUrl
    And request requestPayload
    When method POST
    Then status 201
    #Verification
    And match response.data.attributes.producerCodes[*].id contains requestPayload.data.attributes.producerCodes[0].id
    And match response.data.attributes.accountHolder.displayName == requestPayload.included.AccountContact[0].attributes.firstName + ' ' + requestPayload.included.AccountContact[0].attributes.lastName
    * def accountAttributes =
    """
      {
        'holderId': #(response.data.attributes.accountHolder.id),
        'holderDisplayName': #(response.data.attributes.accountHolder.displayName),
        'id': #(response.data.attributes.id),
        'producerCodeId': #(requestPayload.data.attributes.producerCodes[0].id),
        'locationId': #(requestPayload.included.AccountContact[0].attributes.primaryAddress.id),
        'addressLine1': #(requestPayload.included.AccountContact[0].attributes.primaryAddress.addressLine1),
        'city': #(requestPayload.included.AccountContact[0].attributes.primaryAddress.city),
        'postalCode': #(requestPayload.included.AccountContact[0].attributes.primaryAddress.postalCode),
        'stateCode': #(requestPayload.included.AccountLocation[0].attributes.state.code)
      }
    """
    * setStepVariable('accountAttributes', accountAttributes)

  @id=GetAccountLocation
  Scenario:  Get an account location
    * def requiredScenarioArguments = ['accountId']
    * def accountLocationsUrl = accountsUrl +  "/" + __arg.scenarioArgs.accountId + '/locations'
    * def emptyRequestTemplate = policyPath + 'emptyRequest.json'
    Given url accountLocationsUrl
    And request read(emptyRequestTemplate)
    When method GET
    Then status 200
    And setStepVariable('locationId', response.data[0].attributes.id)
