Feature: Claim
  Step scenarios that operate on Claims

  Background:
    * def username = claimsDataContainer.getClaimsUser(__arg.cucumberDataCache.currentUserRole).getName()

  @id=CreateAPAClaim
  Scenario: a Personal Auto claim
    * __arg.cucumberDataCache.policyVehicleId = 'pcveh:1'
    * __arg.cucumberDataCache.policyInsuredId= 'pc:contact_1'
    * __arg.cucumberDataCache.lineOfBusiness = 'PersonalAuto'
    When step('PolicyActions.CreatePolicy', {'scenarioArgs': {'lineOfBusiness': __arg.cucumberDataCache.lineOfBusiness}, 'templateArgs': {'policyVehicleId': __arg.cucumberDataCache.policyVehicleId, 'policyInsuredId': __arg.cucumberDataCache.policyInsuredId}})
    * def policyNumber = getStepVariable('PolicyActions.CreatePolicy','policyNumber')
    And step('ClaimActions.CreateClaim', {'scenarioArgs': {'username': username, 'lineOfBusiness': __arg.cucumberDataCache.lineOfBusiness},'templateArgs': {'policyNumber': policyNumber}})
    * def claimId = getStepVariable('ClaimActions.CreateClaim','claimId')
    * __arg.cucumberDataCache.claimId = claimId
    * __arg.cucumberDataCache.insuredId = getStepVariable('ClaimActions.CreateClaim','insuredId')
    And step('ClaimActions.SubmitClaimAndAutoAssign', {'scenarioArgs': {'username': username, 'draftClaimId': claimId}})

  @id=CreateHOClaim
  Scenario: a Homeowners claim
    * __arg.cucumberDataCache.lineOfBusiness = 'Homeowners'
    When step('PolicyActions.CreatePolicy', {'scenarioArgs': {'lineOfBusiness': __arg.cucumberDataCache.lineOfBusiness}, 'templateArgs': {}})
    * def policyNumber = getStepVariable('PolicyActions.CreatePolicy', 'policyNumber')
    And step('ClaimActions.CreateClaim', {'scenarioArgs': {'username': username, 'lineOfBusiness': __arg.cucumberDataCache.lineOfBusiness}, 'templateArgs': {'policyNumber': policyNumber}})
    * def claimId = getStepVariable('ClaimActions.CreateClaim', 'claimId')
    * __arg.cucumberDataCache.claimId = claimID
    * __arg.cucumberDataCache.insuredId = getStepVariable('ClaimActions.CreateClaim', 'insuredId')
    And step('ClaimActions.SubmitClaimAndAutoAssign', {'scenarioArgs': {'username': username, 'draftClaimId': claimId}}

  @id=CreateClaim
  Scenario: I create a claim
    And step('ClaimActions.CreateClaim', {'scenarioArgs': {'username': username, 'lineOfBusiness': __arg.cucumberDataCache.lineOfBusiness},'templateArgs': {'policyNumber': __arg.cucumberDataCache.policyNumber}})
    * __arg.cucumberDataCache.claimId = getStepVariable('ClaimActions.CreateClaim','claimId')
    * __arg.cucumberDataCache.insuredId = getStepVariable('ClaimActions.CreateClaim','insuredId')
    And step('ClaimActions.SubmitClaimAndAutoAssign', {'scenarioArgs': {'username': username, 'draftClaimId': __arg.cucumberDataCache.claimId}})

  @id=CreateDraftClaim
  Scenario: a draft claim
    When step('ClaimActions.CreateClaim', {'scenarioArgs': {'username': username, 'lineOfBusiness': __arg.cucumberDataCache.lineOfBusiness},'templateArgs': {'policyNumber': __arg.cucumberDataCache.policyNumber}})
    * __arg.cucumberDataCache.claimId = getStepVariable('ClaimActions.CreateClaim','claimId')
    * __arg.cucumberDataCache.insuredId = getStepVariable('ClaimActions.CreateClaim','insuredId')

  @id=SubmitDraftClaim
  Scenario: the claim is submitted
    When step('ClaimActions.SubmitClaimAndAutoAssign', {'scenarioArgs': {'username': username, 'draftClaimId': __arg.cucumberDataCache.claimId}})

  @id=UpdateLossLocation
  Scenario: the loss location is in
    * def parameters = ['city','state']
    When step('ClaimActions.UpdateLossLocation', {'scenarioArgs': {'username': username, 'claimId': __arg.cucumberDataCache.claimId}, 'templateArgs': {'city': __arg.parameters.city, 'state': __arg.parameters.state}})

  @id=UpdateLossCause
  Scenario: the loss cause was a {string}
    * def parameters = ["lossCause"]
    * def unrestrictedUsername = claimUtils.getUnrestrictedUser()
    When step('ClaimActions.UpdateLossCause', {'scenarioArgs': {'username': unrestrictedUsername, 'claimId': __arg.cucumberDataCache.claimId}, 'templateArgs': {'lossCause': __arg.parameters.lossCause}})

  @id=ClaimAssignedTo
  Scenario: the claim was assigned to the {string}
    * def parameters = ['group']
    * def unrestrictedUsername = claimUtils.getUnrestrictedUser()
    Given step('ClaimActions.GetClaim', {'scenarioArgs': {'username': unrestrictedUsername, 'claimId': __arg.cucumberDataCache.claimId, 'insuredId': __arg.cucumberDataCache.insuredId}})
    * def claimAssignedGroup = getStepVariable('ClaimActions.GetClaim', 'claimAssignedGroup')
    When step('ClaimActions.MatchClaimAssignedGroup', {'scenarioArgs': {'claimAssignedGroup': claimAssignedGroup, 'group': __arg.parameters.group}})
