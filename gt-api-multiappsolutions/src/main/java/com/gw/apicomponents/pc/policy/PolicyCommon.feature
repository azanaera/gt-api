Feature: As a user I want to perform actions on policy

  Background:
    * def username = policyusername
    * def password = policypassword
    * def policyPath = 'classpath:com/gw/apicomponents/pc/policy/'
    * def accountUrl = pcBaseUrl + '/rest/account/v1/accounts'
    * def submissionUrl = pcBaseUrl + '/rest/job/v1/submissions'
    * def jobUrl = pcBaseUrl + '/rest/job/v1/jobs'
    * def policyUrl = pcBaseUrl + '/rest/policy/v1/policies'

    * configure headers = read('classpath:headers.js')

  @id=SubmitPolicy
  Scenario: Create a Business Auto Policy
    * def addAutoPolicyTemplate = policyPath + 'addPolicy.json'
    Given url submissionUrl
    And request readWithArgs(addAutoPolicyTemplate,  __arg.templateArgs)
    When method POST
    Then status 201
    And setStepVariable('submissionId', response.data.attributes.id)

  @id=GetPolicyLocationId
  Scenario: Get Policy Location
    * def requiredArguments = ['submissionId']
    * def policyLocationUrl = jobUrl +  "/" + __arg.scenarioArgs.submissionId + '/locations'
    Given url policyLocationUrl
    When method GET
    Then status 200
    * def locationid = karate.jsonPath(response, 'data[0].attributes.id')
    And setStepVariable('locationid', locationid)

  @id=ValidatePolicyCost
  Scenario: Validate Policy Cost
    * def requiredArguments = ['username','policyId']
    * def getPolicyUrl = policyUrl +  "/" + __arg.scenarioArgs.policyId
    * def username = __arg.scenarioArgs.username
    Given url getPolicyUrl
    When method GET
    Then status 200
    And match response.data.attributes.taxesAndSurcharges.amount == '#present'
    And match response.data.attributes.taxesAndSurcharges.currency == '#present'
    And match response.data.attributes.totalCost.amount == '#present'
    And match response.data.attributes.totalCost.currency == '#present'
    And match response.data.attributes.totalPremium.amount == '#present'
    And match response.data.attributes.totalPremium.currency == '#present'

  @id=ChangePolicy
  Scenario: Change Policy
    * def requiredArguments = ['policyId']
    * def policyChangeRequest = policyPath + 'changePolicy.json'
    * def policyChangeUrl = policyUrl +  "/" + __arg.scenarioArgs.policyId + '/change'
    Given url policyChangeUrl
    And request readWithArgs(policyChangeRequest,  __arg.templateArgs)
    When method POST
    Then status 201
    And setStepVariable('jobId', response.data.attributes.id)

  @id=QuotePolicy
  Scenario: Quote Policy
    * def requiredArguments = ['submissionId']
    * def emptyRequestTemplate = policyPath + 'emptyRequest.json'
    * def quoteUrl = jobUrl +  "/" + __arg.scenarioArgs.submissionId + '/quote'
    Given url quoteUrl
    And request read(emptyRequestTemplate)
    When method POST
    Then status 200
    And setStepVariable('jobId', response.data.attributes.id)

  @id=WithdrawPolicy
  Scenario: Withdraw Policy
    * def requiredArguments = ['submissionId']
    * def emptyRequestTemplate = policyPath + 'emptyRequest.json'
    * def quoteUrl = jobUrl +  "/" + __arg.scenarioArgs.submissionId + '/withdraw'
    Given url quoteUrl
    And request read(emptyRequestTemplate)
    When method POST
    Then status 200
    And setStepVariable('jobId', response.data.attributes.id)

  @id=ValidatePolicyPermissions
  Scenario: Validate Policy Permissions
    * def requiredArguments = ['username','policyId','userMessage']
    * def username = __arg.scenarioArgs.username
    * def getPolicyUrl = policyUrl +  "/" + __arg.scenarioArgs.policyId
    Given url getPolicyUrl
    When method GET
    Then status 404
    And match response.userMessage == __arg.scenarioArgs.userMessage