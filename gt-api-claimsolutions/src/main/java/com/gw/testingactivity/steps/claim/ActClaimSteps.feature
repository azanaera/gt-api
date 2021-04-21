Feature: Claim
  Step scenarios that operate on Claims

  Background:
    * def username = claimsDataContainer.getClaimsUser(__arg.cucumberDataCache.currentUserRole).getName()
    * def unrestrictedUsername = claimUtils.getUnrestrictedUser()

  @id=CreateAHOClaim
  Scenario: a Homeowners policy claim
    * __arg.cucumberDataCache.lineOfBusiness = 'Homeowners'
    When step('ActPolicyActions.CreatePolicy', {'scenarioArgs': {'lineOfBusiness': __arg.cucumberDataCache.lineOfBusiness}, 'templateArgs': {}})
    * def policyNumber = getStepVariable('ActPolicyActions.CreatePolicy','policyNumber')
    * __arg.cucumberDataCache.policyNumber = getStepVariable('ActPolicyActions.CreatePolicy','policyNumber')
    And step('ActClaimsAction.CreateClaim', {'scenarioArgs': {'username': username, 'lineOfBusiness': __arg.cucumberDataCache.lineOfBusiness},'templateArgs': {'policyNumber': policyNumber}})
    * def claimId = getStepVariable('ActClaimsAction.CreateClaim','claimId')
    * __arg.cucumberDataCache.claimId = claimId
    * __arg.cucumberDataCache.insuredId = getStepVariable('ActClaimsAction.CreateClaim','insuredId')
    And step('ActClaimsAction.SubmitClaimAndAutoAssign', {'scenarioArgs': {'username': username, 'draftClaimId': claimId}})
    * __arg.cucumberDataCache.claimOwnerId = getStepVariable('ActClaimsAction.SubmitClaimAndAutoAssign', 'claimOwnerId')
    * __arg.cucumberDataCache.claimAssignedGroup = getStepVariable('ActClaimsAction.SubmitClaimAndAutoAssign', 'claimAssignedGroup')
    * __arg.cucumberDataCache.claimNumber = getStepVariable('ActClaimsAction.SubmitClaimAndAutoAssign', 'claimNumber')


  @id=SearchClaim
  Scenario: I search for the claim with {string}
    * def parameters = ['identifier']
    * step('ActClaimsAction.SearchClaim', {'scenarioArgs': {'username': unrestrictedUsername, 'identifier': __arg.parameters.identifier}, 'templateArgs': __arg.cucumberDataCache})
    * __arg.cucumberDataCache.listOfClaims = getStepVariable('ActClaimsAction.SearchClaim','listOfClaims')


  @id=ClaimFound
  Scenario: the claim was found using claim number;I could find the claim
    * step('ActClaimsAction.MatchClaimByClaimId', {'scenarioArgs': {'username': username, 'listOfClaims': __arg.cucumberDataCache.listOfClaims, 'claimId': __arg.cucumberDataCache.claimId}})
