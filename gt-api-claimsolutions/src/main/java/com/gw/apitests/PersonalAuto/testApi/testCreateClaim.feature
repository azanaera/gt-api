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
    Given step('aaaPolicies.CreatePolicy', {'scenarioArgs': {'lineOfBusiness': 'PersonalAuto'}, 'templateArgs': {}})
    * def PAPolicyNumber = getStepVariable('Policies.CreatePolicy','policyNumber')
#    When step('Claims.CreateClaim', {'scenarioArgs': {'lineOfBusiness': 'PersonalAuto'},'templateArgs': {'policyNumber': PAPolicyNumber}})
#    * def claimId = getStepVariable('Claims.CreateClaim','claimId')
#    And step('Claims.SubmitClaim', {'scenarioArgs': {'draftClaimId': claimId}, 'templateArgs':{'groupId': adjuster.getGroupId(),'userId': adjuster.getId()}})
#    * def insuredId = getStepVariable('Claims.SubmitClaim','insuredId')
