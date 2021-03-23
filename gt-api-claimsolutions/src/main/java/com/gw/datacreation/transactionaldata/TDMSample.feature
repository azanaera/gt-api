Feature: Check with multiple line items
  As an adjuster I want to create a PA claim with an incident, exposure, reserves lines, check with multiple line items

  Background:
    Given step('CreateClaimAdminData.CCAdminData')
    * def adjuster = claimsDataContainer.getClaimsUser("ccadjuster1")
    * def username = adjuster.getName()
    * def password = claimsDataContainer.getPassword()
    * def claimsUrl = ccBaseUrl + '/rest/claim/v1/claims'
    * def commonUrl = ccBaseUrl + '/rest/common/v1'
    * configure headers = read('classpath:headers.js')
    * def transaction_amount = '100.00'
    * def transaction_amount1 = '50.00'
    * def reserveAmount = '500.00'
    * def transactionAmount = '150.00'
    * def currency = 'usd'

  @id=RunPACheck
  Scenario: Check with multiple line items
 #  create claim, Incident, Exposure , Check with Multiple Line Items
    Given step('Policies.CreatePolicy', {'scenarioArgs': {'lineOfBusiness': 'PersonalAuto'}, 'templateArgs': {}})
    * def PAPolicyNumber = getStepVariable('Policies.CreatePolicy','policyNumber')
    When step('Claims.CreateClaim', {'scenarioArgs': {'lineOfBusiness': 'PersonalAuto'},'templateArgs': {'policyNumber': PAPolicyNumber}})
    * def claimId = getStepVariable('Claims.CreateClaim','claimId')
    And step('Claims.SubmitClaim', {'scenarioArgs': {'draftClaimId': claimId}, 'templateArgs':{'groupId': adjuster.getGroupId(),'userId': adjuster.getId()}})
    * def insuredId = getStepVariable('Claims.SubmitClaim','insuredId')
    And step('Incidents.CreateVehicleIncident', {'scenarioArgs':{'claimId': claimId}, 'templateArgs': {'insuredId': insuredId}})
    * def incidentId = getStepVariable('Incidents.CreateVehicleIncident','incidentId')
    * def damageDescription = getStepVariable('Incidents.CreateVehicleIncident','damageDescription')
    And step('Exposures.CreateVehicleIncidentExposure', {'scenarioArgs': {'claimId': claimId}, 'templateArgs': {'insuredId': insuredId, 'incidentId': incidentId}})
    * def exposureId = getStepVariable('Exposures.CreateVehicleIncidentExposure','exposureId')
    And step('Reserves.CreateReserveForExposure', {'scenarioArgs': {'claimId': claimId}, 'templateArgs': {'exposureId': exposureId, 'amount': reserveAmount, 'currency': currency}})
    And step('CreateCheckWithMultipleLineItems.CreateCheckWithMultipleLineItems', {'scenarioArgs': {'claimId': claimId}, 'templateArgs': {'insuredId': insuredId , 'exposureId': exposureId, 'amount' : transaction_amount, 'currency' : currency, 'amount1' : transaction_amount1}})

  #  get Claim and Exposure
    And step('Claims.GetClaim', {'scenarioArgs': {'claimId': claimId, 'insuredId': insuredId}})
    And step('Incidents.GetVehicleIncident', {'scenarioArgs': {'claimId': claimId,'incidentId': incidentId,'damageDescription': damageDescription}})
    And step('Exposures.GetExposure', {'scenarioArgs': {'claimId': claimId,'exposureId': exposureId,  'jurisdictionCode':'AZ'}})

  #  close Activities, Exposure and Claim
    And step('Activities.CloseAllActivities', {'scenarioArgs': {'claimId': claimId}})
    And step('Exposures.CloseExposure', {'scenarioArgs': {'claimId': claimId, 'exposureId': exposureId}})
    Then step('Claims.CloseClaim', {'scenarioArgs': {'claimId': claimId}})


