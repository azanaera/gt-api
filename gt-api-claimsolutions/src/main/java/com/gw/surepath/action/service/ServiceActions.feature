Feature: Service Request
  As an adjuster I want to perform actions on service requests

  Background:
    * def username = __arg.scenarioArgs.username
    * def password = claimsDataContainer.getPassword()
    * def claimsUrl = ccBaseUrl + '/rest/claim/v1/claims'
    * configure headers = read('classpath:headers.js')

  @id=CreateServiceRequest
  Scenario: Create a service request
    * def requiredArguments = ['claimId']
    Given url claimsUrl + '/' + __arg.scenarioArgs.claimId + '/service-requests'
    And request readWithArgs('classpath:com/gw/surepath/action/service/createServiceRequest.json', __arg.templateArgs)
    When method POST
    Then status 201
    * match response.data.attributes.kind.code == __arg.templateArgs.kindCode
    * match response.data.attributes.instruction.services[*].code contains __arg.templateArgs.serviceCode
    * setStepVariable('serviceId', response.data.attributes.id)

  @id=SubmitServiceRequest
  Scenario: Submit service request
    * def requiredArguments = ['claimId', 'serviceRequestId']
    * def submitServiceRequestTemplate = 'classpath:com/gw/apicomponents/EmptyRequest.json'
    * def submitServiceRequestUrl = claimsUrl + '/' + __arg.scenarioArgs.claimId + '/service-requests/'+ __arg.scenarioArgs.serviceRequestId + '/submit'
    Given url submitServiceRequestUrl
    And request read(submitServiceRequestTemplate)
    When method POST
    Then status 200