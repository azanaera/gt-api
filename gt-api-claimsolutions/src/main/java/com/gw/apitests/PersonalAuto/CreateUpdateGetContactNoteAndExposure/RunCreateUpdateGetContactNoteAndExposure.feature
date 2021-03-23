# Note: These test scenarios are included for illustrative purposes only and are
# dependent on the TestSupport APIs and the ClaimServicingApis being enabled.
Feature: Create, update and get contact, note and exposure
  As an adjuster I want to create a PersonalAuto claim with an associated incident, exposure, contact and notes on the claim,
  then update contact, exposure and notes and then get the created claim, incident and the updated contact, exposure and notes

  Background:
    Given step('CreateClaimAdminData.CCAdminData')
    * def adjuster = claimsDataContainer.getClaimsUser("ccadjuster1")
    * def username = adjuster.getName()
    * def password = claimsDataContainer.getPassword()
    * def claimsUrl = ccBaseUrl + '/rest/claim/v1/claims'
    * def commonUrl = ccBaseUrl + '/rest/common/v1'
    * configure headers = read('classpath:headers.js')


  @RunAll
  @id=RunPA
  Scenario: Create, update and get contact, note and exposure

  # Create claim, Incident
    Given step('Policies.CreatePolicy', {'scenarioArgs': {'lineOfBusiness': 'PersonalAuto'}, 'templateArgs': {}})
    * def PAPolicyNumber = getStepVariable('Policies.CreatePolicy','policyNumber')
    When step('Claims.CreateClaim', {'scenarioArgs': {'lineOfBusiness': 'PersonalAuto'},'templateArgs': {'policyNumber': PAPolicyNumber}})
    * def claimId = getStepVariable('Claims.CreateClaim','claimId')
    And step('Claims.SubmitClaim', {'scenarioArgs': {'draftClaimId': claimId}, 'templateArgs':{'groupId': adjuster.getGroupId(),'userId': adjuster.getId()}})
    * def insuredId = getStepVariable('Claims.SubmitClaim','insuredId')
    And step('Incidents.CreateVehicleIncident', {'scenarioArgs':{'claimId': claimId}, 'templateArgs': {'insuredId': insuredId}})
    * def incidentId = getStepVariable('Incidents.CreateVehicleIncident','incidentId')
    * def damageDescription = getStepVariable('Incidents.CreateVehicleIncident','damageDescription')

  # Create New Contact, Exposure and Note
    And step('Contacts.CreateNewContact',{'scenarioArgs': {'claimId': claimId}})
    * def contactId = getStepVariable('Contacts.CreateNewContact','contactId')
    And step('Exposures.CreateVehicleIncidentExposure', {'scenarioArgs': {'claimId': claimId}, 'templateArgs': {'insuredId': insuredId, 'incidentId': incidentId}})
    * def exposureId = getStepVariable('Exposures.CreateVehicleIncidentExposure','exposureId')
    And step('Notes.CreateNote', {'scenarioArgs': {'claimId': claimId}, 'templateArgs': {'claimId':claimId, 'body':'Create Note on Personal Auto claim', 'confidential':false, 'subject':'Test Note on CA', 'topic':'general'}})
    * def noteId = getStepVariable('Notes.CreateNote','noteId')

  # Update Contact, Exposure and Note
    And step('Contacts.UpdateContactLastName', {'scenarioArgs': {'claimId': claimId,'contactId': contactId}, 'templateArgs': {'lastName':'Tester'}})
    And step('Exposures.UpdateExposureJurisdiction', {'scenarioArgs': {'claimId': claimId, 'exposureId':exposureId}, 'templateArgs': {'jurisdictionCode':'CA','insuredId':insuredId}})
    And step('Notes.UpdateNote', {'scenarioArgs': {'claimId': claimId, 'noteId':noteId}, 'templateArgs': {'claimId':claimId, 'confidential':true,'subject':'Test Update Note on CA','topic':'coverage'}})

  # Get Claim, Incident, Contact, Exposure and Note
    And step('Claims.GetClaim', {'scenarioArgs': {'claimId': claimId, 'insuredId': insuredId}})
    And step('Incidents.GetVehicleIncident', {'scenarioArgs': {'claimId': claimId,'incidentId': incidentId,'damageDescription': damageDescription}})
    And step('Contacts.GetContact', {'scenarioArgs': {'claimId': claimId,'contactId': contactId, 'lastName': 'Tester'}})
    And step('Exposures.GetExposure', {'scenarioArgs': {'claimId': claimId,'exposureId': exposureId, 'jurisdictionCode':'CA'}})
    And step('Notes.GetNote', {'scenarioArgs': {'claimId': claimId,'noteId': noteId,'confidential':true,'subject':'Test Update Note on CA','topic':'coverage'}})

  # Close Exposure, Activities and Claim
    And step('Activities.CloseAllActivities',{'scenarioArgs': {'claimId': claimId}})
    And step('Exposures.CloseExposure', {'scenarioArgs': {'claimId': claimId, 'exposureId': exposureId}})
    Then step('Claims.CloseClaim', {'scenarioArgs': {'claimId': claimId}})


