# Note: These test scenarios are included for illustrative purposes only
# and are dependent on appropriate line of business setup.
Feature: CC-PC API integration
  As an adjuster I want to create Commercial Auto claim with associated incident, exposure and search
  for claims based on policy number created by PC API and close the claim.

  Background:
    * def adjuster = claimsDataContainer.getClaimsUser("ccadjuster1")
    * def claimusername = adjuster.getName()
    * def claimpassword = claimsDataContainer.getPassword()
    * def claimsUrl = ccBaseUrl + '/rest/claim/v1/claims'
    * def claimcommonUrl = ccBaseUrl + '/rest/common/v1'

    * def underwriter = policyDataContainer.getPolicyUser("pcunderwriter")
    * def policyusername = underwriter.getName()
    * def policypassword = policyDataContainer.getPassword()
    * def policyUrl = pcBaseUrl + '/rest/job/v1/jobs'
    * def policycommonUrl = pcBaseUrl + '/rest/common/v1'
    * def jobEffectiveDate = new Date().toISOString().split("T")[0]


  @RunAll
  @id=RunInt
  Scenario: Claim life cycle with policy created with PC API
  # Create CA Policy with PC API
    Given step('Accounts.AddCompany', {'templateArgs': {'accountContactCompanyName': 'Company Test Bind Only'}})
    * def companyId = getStepVariable('Accounts.AddCompany', 'id')
    When step('PolicyCommon.SubmitPolicy', {'templateArgs': {'companyId': companyId, 'jobEffectiveDate': jobEffectiveDate}})
    * def draftSubmissionId = getStepVariable('PolicyCommon.SubmitPolicy','submissionId')
    And step('BAJob.PatchBusinessAutoPolicyType', {'templateArgs': { }, 'scenarioArgs': {'submissionId':draftSubmissionId}})
    And step('PolicyCommon.GetPolicyLocationId', {'scenarioArgs': {'submissionId':draftSubmissionId}})
    And step('BAJob.CreateBusinessVehicle',{'templateArgs': {'locationId':getStepVariable('PolicyCommon.GetPolicyLocationId','locationid'),'vehicleVIN': '12345'}, 'scenarioArgs': {'submissionId':draftSubmissionId} })
    And step('BAJob.SyncLineItems', {'scenarioArgs': {'submissionId':draftSubmissionId,'syncType':'Coverages'}})
    And step('PolicyCommon.QuotePolicy', {'scenarioArgs': {'submissionId':draftSubmissionId}})
    And step('JobCommon.BindOnlyJob', {'scenarioArgs': {'jobId':draftSubmissionId}})
    * def policyId = getStepVariable('JobCommon.BindOnlyJob','policyId')
    * def CAPolicyNumber = getStepVariable('JobCommon.BindOnlyJob','policyNumber')

  #  Create CA claim with Policy Created with PC API
    When step('Claims.CreateClaim', {'scenarioArgs': {'lineOfBusiness': 'CommercialAuto'}, 'templateArgs': {'policyNumber': CAPolicyNumber}})
    * def claimId = getStepVariable('Claims.CreateClaim','claimId')
    * def mainContactId = getStepVariable('Claims.CreateClaim','mainContactId')
    And step('Claims.SubmitClaim', {'scenarioArgs': {'draftClaimId': claimId}, 'templateArgs':{'groupId': adjuster.getGroupId(),'userId': adjuster.getId()}})
    * def insuredId = getStepVariable('Claims.SubmitClaim','insuredId')

  #  Create Incident and Exposure
    And step('Incidents.CreateInjuryIncident', {'scenarioArgs':{'claimId': claimId}, 'templateArgs': {'injuredPersonId':mainContactId}})
    * def injuryIncidentId = getStepVariable('Incidents.CreateInjuryIncident','injuryIncidentId')
    And step('Exposures.CreateInjuryIncidentExposure', {'scenarioArgs': {'claimId': claimId}, 'templateArgs': {'incidentId': injuryIncidentId}})
    * def exposureId = getStepVariable('Exposures.CreateInjuryIncidentExposure','exposureId')

  #  Search CA claim based on Policy
    And step('SearchClaimsBasedOnPolicy.FindClaims', {'scenarioArgs': {'expectedClaims': {'firstClaimId': claimId}, 'policyNumber': CAPolicyNumber, 'maxPageOffset': 500}})

  #  Close activities and exposures
    And step('Activities.CloseAllActivities',{'scenarioArgs': {'claimId': claimId}})
    And step('Exposures.CloseExposures', {'scenarioArgs': {'claimId': claimId}})
    Then step('Claims.CloseClaim', {'scenarioArgs': {'claimId': claimId}})