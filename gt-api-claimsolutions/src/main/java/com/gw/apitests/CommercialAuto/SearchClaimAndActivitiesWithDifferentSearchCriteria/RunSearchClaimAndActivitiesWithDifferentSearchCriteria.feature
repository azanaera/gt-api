# Note: These test scenarios are included for illustrative purposes only and are
# dependent on the TestSupport APIs and the ClaimServicingApis being enabled.
Feature: Search claim and activities with different search criteria
  As an adjuster I want to create Commercial Auto claims with associated incidents, exposures and contact and search
  for claims based on policy number, party involved and then search for a list of activities associated with a user,
  and close the claims.

  Background:
    Given step('CreateClaimAdminData.CCAdminData')
    * def adjuster = claimsDataContainer.getClaimsUser("ccadjuster1")
    * def username = adjuster.getName()
    * def password = claimsDataContainer.getPassword()
    * def claimsUrl = ccBaseUrl + '/rest/claim/v1/claims'
    * def commonUrl = ccBaseUrl + '/rest/common/v1'
    * configure headers = read('classpath:headers.js')
    * def reporter = {'firstName':'Rob', 'lastName': 'Premier', 'RefId': 'premier'}

  @RunAll
  @id=RunCA
  Scenario: Search claim and activities with different search criteria
    Given step('Policies.CreatePolicy', {'scenarioArgs': {'lineOfBusiness': 'CommercialAuto'}, 'templateArgs': {}})
    * def CAPolicyNumber = getStepVariable('Policies.CreatePolicy','policyNumber')

  #  Create CA claim with given reporter
    When step('Claims.CreateClaim', {'scenarioArgs': {'lineOfBusiness': 'CommercialAuto'}, 'templateArgs': {'policyNumber': CAPolicyNumber, 'reporterFirstName': reporter.firstName, 'reporterLastName': reporter.lastName,'refid': reporter.RefId}})
    * def claimId = getStepVariable('Claims.CreateClaim','claimId')
    * def reporterId = getStepVariable('Claims.CreateClaim','reporterId')
    * def mainContactId = getStepVariable('Claims.CreateClaim','mainContactId')
    And step('Claims.SubmitClaim', {'scenarioArgs': {'draftClaimId': claimId}, 'templateArgs':{'groupId': adjuster.getGroupId(),'userId': adjuster.getId()}})
    * def insuredId = getStepVariable('Claims.SubmitClaim','insuredId')

  #  Create Incident and Exposure
    And step('Incidents.CreateInjuryIncident', {'scenarioArgs':{'claimId': claimId}, 'templateArgs': {'injuredPersonId': mainContactId}})
    * def injuryIncidentId = getStepVariable('Incidents.CreateInjuryIncident','injuryIncidentId')
    And step('Exposures.CreateInjuryIncidentExposure', {'scenarioArgs': {'claimId': claimId}, 'templateArgs': {'incidentId': injuryIncidentId}})
    * def exposureId = getStepVariable('Exposures.CreateInjuryIncidentExposure','exposureId')

  #  Create CA second claim
    And step('Claims.CreateClaim', {'scenarioArgs': {'lineOfBusiness': 'CommercialAuto'}, 'templateArgs': {'policyNumber': CAPolicyNumber}})
    * def secondClaimId = getStepVariable('Claims.CreateClaim','claimId')
    And step('Claims.SubmitClaim', {'scenarioArgs': {'draftClaimId': secondClaimId}, 'templateArgs':{'groupId': adjuster.getGroupId(),'userId': adjuster.getId()}})
    And step('Claims.GetClaimPolicy', {'scenarioArgs': {'claimId': secondClaimId,'policyNumber': CAPolicyNumber}})
    * def policyId = getStepVariable('Claims.GetClaimPolicy','policyId')
    And step('SearchClaimsBasedOnPolicyAndReporter.FindClaims', {'scenarioArgs': {'expectedClaims': {'firstClaimId': claimId,'secondClaimId': secondClaimId}, 'policyNumber': CAPolicyNumber, 'maxPageOffset': 500}})
    And step('SearchClaimsBasedOnPolicyAndReporter.FindClaims', {'scenarioArgs': {'expectedClaims': {'firstClaimId': claimId}, 'policyNumber': CAPolicyNumber, 'maxPageOffset': 500, 'reporterFirstName': reporter.firstName, 'reporterLastName':  reporter.lastName}})
    And step('Activities.GetAllActivitiesForCurrentUser')
    * def activitiesCount = getStepVariable('Activities.GetAllActivitiesForCurrentUser', 'activitiesCount')
    * def currentUser = getStepVariable('Activities.GetAllActivitiesForCurrentUser', 'currentUser')

  #  Close activities and exposures
    And step('Activities.CloseAllActivities',{'scenarioArgs': {'claimId': claimId}})
    And step('Activities.CloseAllActivities',{'scenarioArgs': {'claimId': secondClaimId}})
    And step('Exposures.CloseExposures', {'scenarioArgs': {'claimId': claimId}})
  #  Close claims
    Then step('Claims.CloseClaim', {'scenarioArgs': {'claimId': claimId}})
    And  step('Claims.CloseClaim', {'scenarioArgs': {'claimId': secondClaimId}})