Feature: Incident
  Step scenarios that operate on Claim Incidents

  Background:
    * def username = claimsDataContainer.getClaimsUser(__arg.cucumberDataCache.currentUserRole).getName()

  @id=ForInsuredVehicle
  Scenario: for an insured's vehicle
    * def unrestrictedUsername = claimUtils.getUnrestrictedUser()
    When step('IncidentActions.CreateInsuredVehicleIncident', {'scenarioArgs': {'username': unrestrictedUsername, 'claimId': __arg.cucumberDataCache.claimId}, 'templateArgs': {'policyInsuredId': __arg.cucumberDataCache.policyInsuredId, 'policyVehicleId': __arg.cucumberDataCache.policyVehicleId}})
    * __arg.cucumberDataCache.incidentId = getStepVariable('IncidentActions.CreateInsuredVehicleIncident', 'incidentId')

  @id=VehicleIncidentTotalLoss
  Scenario: the vehicle is total loss
    When step('IncidentActions.UpdateVehicleIncidentTotalLoss', {'scenarioArgs': {'username': username, 'claimId': __arg.cucumberDataCache.claimId, 'incidentId': __arg.cucumberDataCache.incidentId}})