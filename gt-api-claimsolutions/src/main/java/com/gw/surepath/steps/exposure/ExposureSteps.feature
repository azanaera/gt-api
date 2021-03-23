Feature: Exposure
  Step scenarios that operate on Claim Exposures

  Background:
    * def username = claimsDataContainer.getClaimsUser(__arg.cucumberDataCache.currentUserRole).getName()

  @id=ExposureAssignedClaimOwner
  Scenario: the exposure is assigned to the claim owner
    * def unrestrictedUsername = claimUtils.getUnrestrictedUser()
    When step('ExposureActions.GetExposure', {'scenarioArgs': {'username': unrestrictedUsername, 'claimId': __arg.cucumberDataCache.claimId, 'exposureId': __arg.cucumberDataCache.exposureId}})
    * def exposureOwnerId = getStepVariable('ExposureActions.GetExposure', 'exposureOwnerId')
    And step('ClaimActions.GetClaim', {'scenarioArgs': {'username': unrestrictedUsername, 'claimId': __arg.cucumberDataCache.claimId, 'insuredId': __arg.cucumberDataCache.insuredId}})
    * def claimOwnerId = getStepVariable('ClaimActions.GetClaim', 'claimOwnerId')
    When step('ExposureActions.MatchExposureOwnerWithClaimOwner', {'scenarioArgs': {'exposureOwnerId': exposureOwnerId, 'claimOwnerId': claimOwnerId}})

  @id=CreateExposureForVehicle
  Scenario: I create an exposure for the vehicle
    * def unrestrictedUsername = claimUtils.getUnrestrictedUser()
    When step('ExposureActions.CreateVehicleIncidentExposure', {'scenarioArgs': {'username': unrestrictedUsername, 'claimId': __arg.cucumberDataCache.claimId}, 'templateArgs': {'incidentId': __arg.cucumberDataCache.incidentId, 'insuredId': __arg.cucumberDataCache.insuredId}})
    * __arg.cucumberDataCache.exposureId = getStepVariable('ExposureActions.CreateVehicleIncidentExposure', 'exposureId')

  @id=CovSubtypeExposureExists
  Scenario: a {string} exposure exists
    * def parameters = ['coverageSubtype']
    * def unrestrictedUsername = claimUtils.getUnrestrictedUser()
    When step('ExposureActions.GetExposureByCovSubtype', {'scenarioArgs': {'username': unrestrictedUsername, 'claimId': __arg.cucumberDataCache.claimId, 'coverageSubtype': __arg.parameters.coverageSubtype}})
