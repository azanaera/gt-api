Feature: As a user, I want to modify a job

  Background:
    * def username = policyusername
    * def password = policypassword
    * def emptyJsonPath = 'classpath:com/gw/apicomponents/pc/policy/'
    * def jobJsonPath = 'classpath:com/gw/apicomponents/pc/job/'
    * def jobUrl = pcBaseUrl + '/rest/job/v1/jobs'
    * def policyBaseUrl = pcBaseUrl + '/rest/policy/v1/policies'
    * configure headers = read('classpath:headers.js')

  @id=MakeDraftJob
  Scenario: Make Draft a job
    * def requiredArguments = ['jobId']
    * def emptyRequestTemplate = emptyJsonPath + 'emptyRequest.json'
    * def makeDraftJobUrl = jobUrl + "/" + __arg.scenarioArgs.jobId + '/make-draft'
    Given url makeDraftJobUrl
    And request read(emptyRequestTemplate)
    When method POST
    Then status 200

  @id=WithdrawJob
  Scenario: Withdraw a job
    * def requiredArguments = ['jobId']
    * def emptyRequestTemplate = emptyJsonPath + 'emptyRequest.json'
    * def withdrawJobUrl = jobUrl + "/" + __arg.scenarioArgs.jobId + '/withdraw'
    Given url withdrawJobUrl
    And request read(emptyRequestTemplate)
    When method POST
    Then status 200

  @id=BindAndIssueJob
  Scenario: Bind and Issue a job
    * def requiredArguments = ['jobId']
    * def emptyRequestTemplate = emptyJsonPath + 'emptyRequest.json'
    * def bindJobUrl = jobUrl + "/" + __arg.scenarioArgs.jobId + '/bind-and-issue'
    Given url bindJobUrl
    And request read(emptyRequestTemplate)
    When method POST
    Then status 200
    And setStepVariable('policyId', response.data.attributes.policy.id)
    And setStepVariable('policyNumber', response.data.attributes.policyNumber)

  @id=BindOnlyJob
  Scenario: Bind a job
    * def requiredArguments = ['jobId']
    * def emptyRequestTemplate = emptyJsonPath + 'emptyRequest.json'
    * def bindOnlyJobUrl = jobUrl + "/" + __arg.scenarioArgs.jobId + '/bind-only'
    Given url bindOnlyJobUrl
    And request read(emptyRequestTemplate)
    When method POST
    Then status 200
    And setStepVariable('policyId', response.data.attributes.policy.id)
    And setStepVariable('policyNumber', response.data.attributes.policyNumber)

  @id=PatchJob
  Scenario: Patch a job
    * def requiredArguments = ['jobId']
    * def patchRequestTemplate = jobJsonPath + 'patchJob.json'
    * def patchJobUrl = jobUrl + "/" + __arg.scenarioArgs.jobId
    Given url patchJobUrl
    And request readWithArgs(patchRequestTemplate,  __arg.templateArgs)
    When method PATCH
    Then status 200

  @id=ValidateJobStatus
  Scenario: Validate Job Status
    * def requiredArguments = ['jobId','jobStatus','jobType']
    * def jobStatusUrl = jobUrl +  "/" + __arg.scenarioArgs.jobId
    Given url jobStatusUrl
    When method GET
    Then status 200
    And match response.data.attributes.jobStatus.code == __arg.scenarioArgs.jobStatus
    And match response.data.attributes.jobType.code == __arg.scenarioArgs.jobType

  @id=ValidatePolicyIsIssued
  Scenario: Validate Issue Policy Status
    * def requiredArguments = ['policyId']
    * def jobStatusUrl = policyBaseUrl +  "/" + __arg.scenarioArgs.policyId
    Given url jobStatusUrl
    When method GET
    Then status 200
    And match response.data.links.change.href == '/policy/v1/policies/' + __arg.scenarioArgs.policyId + '/change'
    And match response.data.links.renew.href == '/policy/v1/policies/' + __arg.scenarioArgs.policyId + '/renew'
    And match response.data.links.cancel.href == '/policy/v1/policies/' + __arg.scenarioArgs.policyId + '/cancel'

  @id=ValidatePolicyIsBoundOnly
  Scenario: Validate Bind Only Policy Status
    * def requiredArguments = ['policyId']
    * def jobStatusUrl = policyBaseUrl +  "/" + __arg.scenarioArgs.policyId
    Given url jobStatusUrl
    When method GET
    Then status 200
    And match (typeof response.data.links.change) == 'undefined'
    And match (typeof response.data.links.renew) == 'undefined'
    And match response.data.links.cancel.href == '/policy/v1/policies/' + __arg.scenarioArgs.policyId + '/cancel'

  @id=DeclineJob
  Scenario: Decline job
    * def requiredArguments = ['jobId']
    * def declineUrl = jobUrl +  "/" + __arg.scenarioArgs.jobId + '/decline'
    * def requestPayload = readWithArgs(jobJsonPath + 'rejectJob.json', __arg.templateArgs)
    Given url declineUrl
    And request requestPayload
    When method POST
    Then status 200
    And setStepVariable('jobId', response.data.attributes.id)

  @id=NotTakenJob
  Scenario: Not Taken Job
    * def requiredArguments = ['jobId']
    * def notTakeUrl = jobUrl +  "/" + __arg.scenarioArgs.jobId + '/not-take'
    * def requestPayload = readWithArgs(jobJsonPath + 'rejectJob.json', __arg.templateArgs)
    Given url notTakeUrl
    And request requestPayload
    When method POST
    Then status 200
    And setStepVariable('jobId', response.data.attributes.id)

  @id=VerifyCannotMakeDraftJob
  Scenario: Cannot make draft a job in the wrong status
    * def requiredArguments = ['jobId', 'jobStatusDisplayName']
    * def emptyRequestTemplate = emptyJsonPath + 'emptyRequest.json'
    * def makeDraftUrl = jobUrl +  "/" + __arg.scenarioArgs.jobId + '/make-draft'
    Given url makeDraftUrl
    And request read(emptyRequestTemplate)
    When method POST
    Then status 400
    And match response.errorCode == 'gw.api.rest.exceptions.BadInputException'
    And match response.userMessage == 'Cannot take action \'make-draft\'. See the details element for further information.'
    And match response.details[0].message contains 'Branch Unassigned,'
    And match response.details[0].message contains 'is locked.'
    And match response.details[1].message contains 'Branch Unassigned,'
    And match response.details[1].message contains 'status is \'' + __arg.scenarioArgs.jobStatusDisplayName + '\' but must be in one of the following statuses: Rated, Quoted.'

  @id=AddLocation
  Scenario: Add Location
    * def requiredArguments = ['submissionId']
    * def LocationUrl = jobUrl +  "/" + __arg.scenarioArgs.submissionId + '/locations'
    * def addLocation = jobJsonPath + 'addLocation.json'
    Given url LocationUrl
    And request readWithArgs(addLocation,  __arg.templateArgs)
    When method POST
    Then status 201
    And setStepVariable('locationId', response.data.attributes.id)

  @id=GetContacts
  Scenario: Get Contacts
    * def requiredArguments = ['jobId']
    * def getContactsUrl = jobUrl + "/" + __arg.scenarioArgs.jobId + '/contacts'
    Given url getContactsUrl
    When method GET
    Then status 200
    * setStepVariable('contactDisplayName', response.data[0].attributes.accountContact.displayName)