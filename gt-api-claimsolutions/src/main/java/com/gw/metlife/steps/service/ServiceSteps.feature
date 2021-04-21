Feature: Service Request
  Step scenarios that operate on Service Requests

  Background:
    * def username = claimsDataContainer.getClaimsUser(__arg.cucumberDataCache.currentUserRole).getName()
    * def getKindCode =
    """
      function(serviceKind) {
        switch(serviceKind) {
          case 'Perform Service':
            return 'serviceonly';
          case 'Quote and Perform Service':
            return 'quoteandservice';
          default:
            throw 'Unhandled service kind: ' + serviceKind;
        }
      }
    """
    * def getServiceCode =
    """
      function(service) {
        switch(service) {
          case 'Glass':
            return 'autoinsprepairglass';
          case 'Auto body':
            return 'autoinsprepairbody';
          default:
            throw 'Unhandled service: ' + service;
        }
      }
    """
    * def getServiceAddress =
    """
      function(serviceAddress, username, claimId, insuredId) {
        if (serviceAddress == 'Insured\'s Primary Address') {
          step('ContactActions.GetInsuredPrimaryAddress', {'scenarioArgs':{'username': unrestrictedUsername, 'claimId': claimId, 'insuredId': insuredId}});
          return getStepVariable('ContactActions.GetInsuredPrimaryAddress', 'primaryAddress')
        }
        else {
          throw 'Unhandled service address: ' + serviceAddress
        }
      }
    """

  @id=CreateServiceRequest
  Scenario: a service request with the following
    * def parameters = ['request', 'serviceToPerform', 'serviceAddress']
    * def kindCode = getKindCode(__arg.parameters.request)
    * def serviceCode = getServiceCode(__arg.parameters.serviceToPerform)
    * def claimId = __arg.cucumberDataCache.claimId
    * def insuredId = __arg.cucumberDataCache.insuredId
    * def newSpecialistUri = '/claim/v1/claims/' + claimId + '/contacts'
    * def unrestrictedUsername = claimUtils.getUnrestrictedUser()
    * def address = getServiceAddress(__arg.parameters.serviceAddress,unrestrictedUsername,claimId,insuredId)
    Given step('ServiceActions.CreateServiceRequest', {'scenarioArgs': {'username': unrestrictedUsername, 'claimId': claimId}, 'templateArgs': {'newSpecialistUri': newSpecialistUri, 'customerId': insuredId, 'serviceCode': serviceCode, 'kindCode': kindCode, 'address': address}})
    * __arg.cucumberDataCache.serviceRequestId = getStepVariable('ServiceActions.CreateServiceRequest','serviceRequestId')

  @id=RequestForService
  Scenario: I request a {string} for {string}
    * def parameters = ['serviceKind', 'serviceName']
    * def newSpecialistUri = "/claim/v1/claims/" + __arg.cucumberDataCache.claimId + "/contacts"
    When step('ServiceActions.CreateServiceRequest', {'scenarioArgs': {'username': username, 'claimId': __arg.cucumberDataCache.claimId},'templateArgs': {'customerId': __arg.cucumberDataCache.insuredId , 'refNum': 'servicerequest', 'serviceCode': getServiceCode(__arg.parameters.serviceName), 'newSpecialistUri': newSpecialistUri, 'kindCode': getKindCode(__arg.parameters.serviceKind), 'incidentId': __arg.cucumberDataCache.incidentId}})
    * __arg.cucumberDataCache.serviceRequestId = getStepVariable('ServiceActions.CreateServiceRequest', 'serviceRequestId')
    And step('ServiceActions.SubmitServiceRequest', {'scenarioArgs': {'username': username, 'claimId': __arg.cucumberDataCache.claimId, 'serviceRequestId': __arg.cucumberDataCache.serviceRequestId}})

  @id=ServiceShouldExist
  Scenario: a {string} service of type {string} should be requested on the claim
    * def parameters = ['serviceName', 'serviceKind']
    * def unrestrictedUsername = claimUtils.getUnrestrictedUser()
    When step('ServiceActions.EnsureServiceRequestExists', {'scenarioArgs': {'username': unrestrictedUsername, 'claimId': __arg.cucumberDataCache.claimId, 'serviceRequestId': __arg.cucumberDataCache.serviceRequestId, 'serviceName': __arg.parameters.serviceName, 'serviceKind': __arg.parameters.serviceKind}})