Feature: Service Request

  Background:
    * def username = claimsDataContainer.getClaimsUser(__arg.cucumberDataCache.currentUserRole).getName()
    * def getKindCode =
    """
      function(serviceKind) {
        switch(serviceKind) {
          case 'Perform Service':
            return 'serviceonly'
          default:
            throw 'Unhandled service kind: ' + serviceKind
        }
      }
    """
    * def getServiceCode =
    """
      function(service) {
        switch(service) {
          case 'Glass':
            return 'autoinsprepairglass';
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
    * __arg.cucumberDataCache.serviceId = getStepVariable('ServiceActions.CreateServiceRequest','serviceId')
