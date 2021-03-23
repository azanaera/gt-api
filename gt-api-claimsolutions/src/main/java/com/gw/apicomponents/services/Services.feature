Feature: Service Requests
  As an adjuster I want to perform actions on service request

  @id=CreateRequest
  Scenario: Create service request on a claim
    * def requiredArguments = ['claimId']
    * def createQuoteOnlyRequestTemplate = 'classpath:com/gw/apicomponents/services/createServiceRequest.json'
  # 'kindCode': 'quoteonly', 'serviceonly' or 'quoteandservice' (Quote, Perform-Service, Quote-and-Perform-Service)
    * def addServiceRequestUrl = claimsUrl + '/' + __arg.scenarioArgs.claimId + '/service-requests'
    Given url addServiceRequestUrl
    And request readWithArgs(createQuoteOnlyRequestTemplate, __arg.templateArgs)
    When method POST
    Then status 201
    * match response.data.attributes.progress.name == "Draft"
    * setStepVariable('serviceRequestId', response.data.attributes.id)

  @id=CreateRequestForExposure
  Scenario: Create service request on a claim
    * def requiredArguments = ['claimId']
    * def createQuoteOnlyRequestTemplate = 'classpath:com/gw/apicomponents/services/createServiceRequestForExposure.json'
  # 'kindCode': 'quoteonly', 'serviceonly' or 'quoteandservice' (Quote, Perform-Service, Quote-and-Perform-Service)
    * def addServiceRequestUrl = claimsUrl + '/' + __arg.scenarioArgs.claimId + '/service-requests'
    Given url addServiceRequestUrl
    And request readWithArgs(createQuoteOnlyRequestTemplate, __arg.templateArgs)
    When method POST
    Then status 201
    * match response.data.attributes.progress.name == "Draft"
    * setStepVariable('serviceRequestId', response.data.attributes.id)

  @id=SubmitServiceRequest
  Scenario: Submit service request
    * def requiredArguments = ['claimId', 'serviceRequestId']
    * def submitServiceRequestTemplate = 'classpath:com/gw/apicomponents/EmptyRequest.json'
    * def submitServiceRequestUrl = claimsUrl + '/' + __arg.scenarioArgs.claimId + '/service-requests/'+ __arg.scenarioArgs.serviceRequestId + '/submit'
    Given url submitServiceRequestUrl
    And request read(submitServiceRequestTemplate)
    When method POST
    Then status 200
    * match response.data.attributes.progress.name == "Requested"

  @id=GetServiceRequest
  Scenario: Get the service request data
    * def requiredArguments = ['claimId', 'serviceRequestId']
    * def getServiceRequestUrl = claimsUrl + "/" + __arg.scenarioArgs.claimId + '/service-requests/'+ __arg.scenarioArgs.serviceRequestId
    Given url getServiceRequestUrl
    When method GET
    Then status 200
    * match response.data.attributes.id == __arg.scenarioArgs.serviceRequestId

  @id=VerifyServiceRequest
  Scenario: Verify the service request data
    * def requiredScenarioArguments = ['actualServiceRequest', 'expectedProgress', 'expectedNextStep']
    * match __arg.scenarioArgs.actualServiceRequest.data.attributes.progress.name == __arg.scenarioArgs.expectedProgress
    * match __arg.scenarioArgs.actualServiceRequest.data.attributes.nextStep.name == __arg.scenarioArgs.expectedNextStep

  @id=CompleteServiceRequest
  Scenario: Submit service request
    * def requiredArguments = ['claimId', 'serviceRequestId']
    * def completeServiceRequestTemplate = 'classpath:com/gw/apicomponents/EmptyRequest.json'
    * def completeServiceRequestUrl = claimsUrl + '/' + __arg.scenarioArgs.claimId + '/service-requests/'+ __arg.scenarioArgs.serviceRequestId + '/complete-work'
    Given url completeServiceRequestUrl
    And request read(completeServiceRequestTemplate)
    When method POST
    Then status 200
    * match response.data.attributes.progress.name == "Work Complete"