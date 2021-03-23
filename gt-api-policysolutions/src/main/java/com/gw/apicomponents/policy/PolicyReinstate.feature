Feature: As a user, I want to reinstate a quoted policy

  Background:
    * def policyPath = 'classpath:com/gw/apicomponents/policy/'
    * def jobUrl = pcBaseUrl + '/rest/job/v1/jobs'
    * def policyBaseUrl = pcBaseUrl + '/rest/policy/v1/policies'
    * configure headers = read('classpath:headers.js')

  @id=ReinstatePolicy
  Scenario: Reinstate a policy
    * def requiredArguments = ['policyId']
    * def reinstatePolicyTemplate = policyPath + 'reinstatePolicy.json'
    * def policyUrl = policyBaseUrl + "/" + __arg.scenarioArgs.policyId + '/reinstate'
    Given url policyUrl
    And request read(reinstatePolicyTemplate)
    When method POST
    Then status 201
    And setStepVariable('reinstateJobId', response.data.attributes.id)

  @id=QuoteReinstatedPolicy
  Scenario: Quote Policy
    * def requiredArguments = ['reinstateJobId']
    * def emptyRequestTemplate = policyPath + 'emptyRequest.json'
    * def quoteUrl = jobUrl +  "/" + __arg.scenarioArgs.reinstateJobId + '/quote'
    Given url quoteUrl
    And request read(emptyRequestTemplate)
    When method POST
    Then status 200

  @id=ReinstateJob
  Scenario: Bind and issue a reinstatement
    * def requiredArguments = ['reinstateJobId']
    * def emptyRequestTemplate = policyPath + 'emptyRequest.json'
    * def reinstateUrl = jobUrl +  "/" + __arg.scenarioArgs.reinstateJobId + '/bind-and-issue'
    Given url reinstateUrl
    And request read(emptyRequestTemplate)
    When method POST
    Then status 200

  @id=ValidateReinstateJob
  Scenario: Get Policy Location
    * def requiredArguments = ['reinstateJobId']
    * def reinstateJobUrl = jobUrl +  "/" + __arg.scenarioArgs.reinstateJobId
    Given url reinstateJobUrl
    When method GET
    Then status 200
    And match response.data.attributes.jobStatus.code == 'Bound'
    And match response.data.attributes.jobType.code == 'Reinstatement'

  @id=WithdrawReinstate
  Scenario: Withdraw a reinstatement job
    * def requiredArguments = ['reinstateJobId']
    * def emptyRequestTemplate = policyPath + 'emptyRequest.json'
    * def withdrawReinstateUrl = jobUrl +  "/" + __arg.scenarioArgs.reinstateJobId + '/withdraw'
    Given url withdrawReinstateUrl
    And request read(emptyRequestTemplate)
    When method POST
    Then status 200
    And setStepVariable('withdrawReinstateJobId', response.data.attributes.id)

  @id=ValidateWithdrawReinstateJob
  Scenario: Get Policy Location
    * def requiredArguments = ['withdrawReinstateJobId']
    * def withdrawReinstateJobUrl = jobUrl +  "/" + __arg.scenarioArgs.withdrawReinstateJobId
    Given url withdrawReinstateJobUrl
    When method GET
    Then status 200
    And match response.data.attributes.jobStatus.code == 'Withdrawn'
    And match response.data.attributes.jobType.code == 'Reinstatement'