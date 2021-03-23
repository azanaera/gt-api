Feature: As a user, I want to modify a renewal job

  Background:
    * def jobJsonPath = 'classpath:com/gw/apicomponents/job/'
    * def emptyJsonPath = 'classpath:com/gw/apicomponents/policy/'
    * def jobUrl = pcBaseUrl + '/rest/job/v1/jobs'
    * configure headers = read('classpath:headers.js')

  @id=PendingRenew
  Scenario: Schedule a renewal job
    * def requiredArguments = ['jobId']
    * def pendingRenewJson = jobJsonPath + 'pendingRenew.json'
    * def pendingRenewJobUrl = jobUrl + "/" + __arg.scenarioArgs.jobId + '/pending-renew'
    Given url pendingRenewJobUrl
    And request readWithArgs(pendingRenewJson,  __arg.templateArgs)
    When method POST
    Then status 200
    And match response.data.attributes.jobStatus.code == 'Renewing'
    And match response.data.attributes.jobType.code == 'Renewal'
    And setStepVariable('jobId', response.data.attributes.id)

  @id=PendingNonRenew
  Scenario: Pending non renew a renewal job
    * def requiredArguments = ['jobId']
    * def pendingNonRenewJson = jobJsonPath + 'pendingNonRenew.json'
    * def pendingNonRenewJobUrl = jobUrl + "/" + __arg.scenarioArgs.jobId + '/pending-non-renew'
    Given url pendingNonRenewJobUrl
    And request readWithArgs(pendingNonRenewJson,  __arg.templateArgs)
    When method POST
    Then status 200
    And match response.data.attributes.jobStatus.code == 'NonRenewing'
    And match response.data.attributes.jobType.code == 'Renewal'
    And setStepVariable('jobId', response.data.attributes.id)

  @id=PendingNotTake
  Scenario: Pending not take a renewal job
    * def requiredArguments = ['jobId']
    * def emptyRequestTemplate = emptyJsonPath + 'emptyRequest.json'
    * def pendingNotTakeJobUrl = jobUrl + "/" + __arg.scenarioArgs.jobId + '/pending-not-take'
    Given url pendingNotTakeJobUrl
    And request read(emptyRequestTemplate)
    When method POST
    Then status 200
    And match response.data.attributes.jobStatus.code == 'NotTaking'
    And match response.data.attributes.jobType.code == 'Renewal'
    And setStepVariable('jobId', response.data.attributes.id)