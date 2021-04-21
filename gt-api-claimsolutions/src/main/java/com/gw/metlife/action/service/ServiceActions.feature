Feature: Service Request
  Action scenarios that operate on Service Requests

  Background:
    * def username = __arg.scenarioArgs.username
    * def password = claimsDataContainer.getPassword()
    * def claimsUrl = ccBaseUrl + '/rest/claim/v1/claims'
    * def sharedPath = 'classpath:com/gw/surepath/action/service/'
    * configure headers = read('classpath:headers.js')

  @id=CreateServiceRequest
  Scenario: Create a service request
    * def requiredArguments = ['claimId']
    * def getServiceRequestTemplate =
    """
      function(templateArgs) {
        if (templateArgs.incidentId != null) {
          return sharedPath + 'createServiceRequestForIncident.json';
        } else {
          return sharedPath + 'createServiceRequest.json';
        }
      }
    """
    * def createServiceRequestTemplate = getServiceRequestTemplate(__arg.templateArgs)
    Given url claimsUrl + '/' + __arg.scenarioArgs.claimId + '/service-requests'
    And request readWithArgs(createServiceRequestTemplate, __arg.templateArgs)
    When method POST
    Then status 201
    * match response.data.attributes.kind.code == __arg.templateArgs.kindCode
    * match response.data.attributes.instruction.services[*].code contains __arg.templateArgs.serviceCode
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

  @id=EnsureServiceRequestExists
  Scenario: Ensure service request exists
    * def requiredArguments = ['claimId', 'serviceRequestId', 'serviceName', 'serviceKind']
    * def getServiceRequestUrl = claimsUrl + "/" + __arg.scenarioArgs.claimId + '/service-requests/'+ __arg.scenarioArgs.serviceRequestId
    Given url getServiceRequestUrl
    When method GET
    Then status 200
    * match response.data.attributes.id == __arg.scenarioArgs.serviceRequestId
    * match response.data.attributes.instruction.services[*].name contains __arg.scenarioArgs.serviceName
    * match response.data.attributes.kind.name == __arg.scenarioArgs.serviceKind