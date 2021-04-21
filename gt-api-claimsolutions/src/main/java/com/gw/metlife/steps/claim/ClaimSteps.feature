Feature: Claim
  Step scenarios that operate on Claims

  Background:
    * def username = claimsDataContainer.getClaimsUser(__arg.cucumberDataCache.currentUserRole).getName()
    * def unrestrictedUsername = claimUtils.getUnrestrictedUser()

  @id=CreateAPAClaim
  Scenario: a Personal Auto claim
    * __arg.cucumberDataCache.policyVehicleId = 'pcveh:1'
    * __arg.cucumberDataCache.policyInsuredId= 'pc:contact_1'
    * __arg.cucumberDataCache.lineOfBusiness = 'PersonalAuto'
    When step('PolicyActions.CreatePolicy', {'scenarioArgs': {'lineOfBusiness': __arg.cucumberDataCache.lineOfBusiness}, 'templateArgs': {'policyVehicleId': __arg.cucumberDataCache.policyVehicleId, 'policyInsuredId': __arg.cucumberDataCache.policyInsuredId}})
    * def policyNumber = getStepVariable('PolicyActions.CreatePolicy','policyNumber')
    * __arg.cucumberDataCache.policyNumber = getStepVariable('PolicyActions.CreatePolicy','policyNumber')
    And step('ClaimActions.CreateClaim', {'scenarioArgs': {'username': username, 'lineOfBusiness': __arg.cucumberDataCache.lineOfBusiness},'templateArgs': {'policyNumber': policyNumber}})
    * def claimId = getStepVariable('ClaimActions.CreateClaim','claimId')
    * __arg.cucumberDataCache.claimId = claimId
    * __arg.cucumberDataCache.insuredId = getStepVariable('ClaimActions.CreateClaim','insuredId')
    And step('ClaimActions.SubmitClaimAndAutoAssign', {'scenarioArgs': {'username': username, 'draftClaimId': claimId}})
    * __arg.cucumberDataCache.claimOwnerId = getStepVariable('ClaimActions.SubmitClaimAndAutoAssign', 'claimOwnerId')
    * __arg.cucumberDataCache.claimAssignedGroup = getStepVariable('ClaimActions.SubmitClaimAndAutoAssign', 'claimAssignedGroup')
    * __arg.cucumberDataCache.claimNumber = getStepVariable('ClaimActions.SubmitClaimAndAutoAssign', 'claimNumber')

  @id=CreateAHOClaim
  Scenario: a Homeowners claim
    * __arg.cucumberDataCache.lineOfBusiness = 'Homeowners'
    When step('PolicyActions.CreatePolicy', {'scenarioArgs': {'lineOfBusiness': __arg.cucumberDataCache.lineOfBusiness}, 'templateArgs': __arg.cucumberDataCache})
    * def policyNumber = getStepVariable('PolicyActions.CreatePolicy','policyNumber')
    * __arg.cucumberDataCache.policyNumber = getStepVariable('PolicyActions.CreatePolicy','policyNumber')
    And step('ClaimActions.CreateClaim', {'scenarioArgs': {'username': username, 'lineOfBusiness': __arg.cucumberDataCache.lineOfBusiness},'templateArgs': {'policyNumber': policyNumber}})
    * def claimId = getStepVariable('ClaimActions.CreateClaim','claimId')
    * __arg.cucumberDataCache.claimId = claimId
    * __arg.cucumberDataCache.insuredId = getStepVariable('ClaimActions.CreateClaim','insuredId')
    And step('ClaimActions.SubmitClaimAndAutoAssign', {'scenarioArgs': {'username': username, 'draftClaimId': claimId}})
    * __arg.cucumberDataCache.claimOwnerId = getStepVariable('ClaimActions.SubmitClaimAndAutoAssign', 'claimOwnerId')
    * __arg.cucumberDataCache.claimAssignedGroup = getStepVariable('ClaimActions.SubmitClaimAndAutoAssign', 'claimAssignedGroup')
    * __arg.cucumberDataCache.claimNumber = getStepVariable('ClaimActions.SubmitClaimAndAutoAssign', 'claimNumber')

  @id=CreateClaim
  Scenario: I create a claim
    And step('ClaimActions.CreateClaim', {'scenarioArgs': {'username': username, 'lineOfBusiness': __arg.cucumberDataCache.lineOfBusiness},'templateArgs': {'policyNumber': __arg.cucumberDataCache.policyNumber}})
    * __arg.cucumberDataCache.claimId = getStepVariable('ClaimActions.CreateClaim','claimId')
    * __arg.cucumberDataCache.insuredId = getStepVariable('ClaimActions.CreateClaim','insuredId')
    And step('ClaimActions.SubmitClaimAndAutoAssign', {'scenarioArgs': {'username': username, 'draftClaimId': __arg.cucumberDataCache.claimId}})

  @id=CreateDraftClaim
  Scenario: a draft claim; I create a draft claim; I create a claim without an exposure
    When step('ClaimActions.CreateClaim', {'scenarioArgs': {'username': username, 'lineOfBusiness': __arg.cucumberDataCache.lineOfBusiness},'templateArgs': {'policyNumber': __arg.cucumberDataCache.policyNumber}})
    * __arg.cucumberDataCache.claimId = getStepVariable('ClaimActions.CreateClaim','claimId')
    * __arg.cucumberDataCache.insuredId = getStepVariable('ClaimActions.CreateClaim','insuredId')

  @id=SubmitDraftClaim
  Scenario: the claim is submitted
    When step('ClaimActions.SubmitClaimAndAutoAssign', {'scenarioArgs': {'username': username, 'draftClaimId': __arg.cucumberDataCache.claimId}})
    * __arg.cucumberDataCache.claimOwnerId = getStepVariable('ClaimActions.SubmitClaimAndAutoAssign', 'claimOwnerId')
    * __arg.cucumberDataCache.claimAssignedGroup = getStepVariable('ClaimActions.SubmitClaimAndAutoAssign', 'claimAssignedGroup')

  @id=UpdateLossLocation
  Scenario: the loss location is in
    * def parameters = ['city','state']
    When step('ClaimActions.UpdateLossLocation', {'scenarioArgs': {'username': username, 'claimId': __arg.cucumberDataCache.claimId}, 'templateArgs': {'city': __arg.parameters.city, 'state': __arg.parameters.state}})

  @id=UpdateLossCause
  Scenario: the loss cause was a {string}
    * def parameters = ["lossCause"]
    When step('ClaimActions.UpdateLossCause', {'scenarioArgs': {'username': unrestrictedUsername, 'claimId': __arg.cucumberDataCache.claimId}, 'templateArgs': {'lossCause': __arg.parameters.lossCause}})

  @id=ClaimAssignedTo
  Scenario: the claim was assigned to the {string}
    * def parameters = ['group']
    When step('ClaimActions.MatchClaimAssignedGroup', {'scenarioArgs': {'claimAssignedGroup': __arg.cucumberDataCache.claimAssignedGroup, 'group': __arg.parameters.group}})

  @id=GetClaimSegment
  Scenario: the claim is segmented as {string}
    * def parameters = ['claimSegment']
    Given step('ClaimActions.GetClaimSegment', {'scenarioArgs': {'username': unrestrictedUsername, 'claimId': __arg.cucumberDataCache.claimId, 'claimSegment': __arg.parameters.claimSegment}})

  @id=CreateQuickClaim
  Scenario: I create a quick claim
    * step('ClaimActions.CreateMinimalDraftClaim', {'scenarioArgs': {'username': username}, 'templateArgs': {'policyNumber': __arg.cucumberDataCache.policyNumber}})
    * __arg.cucumberDataCache.claimId = getStepVariable('ClaimActions.CreateMinimalDraftClaim', 'claimId')
    * __arg.cucumberDataCache.insuredId = getStepVariable('ClaimActions.CreateMinimalDraftClaim', 'insuredId')

  @id=UpdateClaimReportedByInsured
  Scenario: is reported by the insured
    * step('ClaimActions.UpdateClaimReportedByInsured', {'scenarioArgs': {'username': username, 'claimId': __arg.cucumberDataCache.claimId}, 'templateArgs': {'reporterId': __arg.cucumberDataCache.insuredId}})

  @id=UpdateLossLocationToInsuredAddress
  Scenario: the loss location was the insured's address
    * step('ContactActions.GetInsuredPrimaryAddress', {'scenarioArgs': {'username': username, 'claimId': __arg.cucumberDataCache.claimId, 'insuredId': __arg.cucumberDataCache.insuredId}})
    * def insuredAddress = getStepVariable('ContactActions.GetInsuredPrimaryAddress', 'primaryAddress')
    * step('ClaimActions.UpdateLossLocation', {'scenarioArgs': {'username': username, 'claimId': __arg.cucumberDataCache.claimId}, 'templateArgs': {'lossLocationId': insuredAddress.id}})

  @id=SearchClaim
  Scenario: I search for the claim with the {string}
    * def parameters = ['identifier']
    * step('ClaimActions.SearchClaim', {'scenarioArgs': {'username': unrestrictedUsername, 'identifier': __arg.parameters.identifier}, 'templateArgs': __arg.cucumberDataCache})
    * __arg.cucumberDataCache.listOfClaims = getStepVariable('ClaimActions.SearchClaim','listOfClaims')

  @id=ClaimFound
  Scenario: the claim was found;I could find the claim
    * step('ClaimActions.MatchClaimByClaimId', {'scenarioArgs': {'username': username, 'listOfClaims': __arg.cucumberDataCache.listOfClaims, 'claimId': __arg.cucumberDataCache.claimId}})

  @id=SearchClaimByContacts
  Scenario: I search for the claim with the claim contact information
    * def parameters = ['claimContact','identifier']
    * def getNameSearchTypeCode =
    """
      function(claimContact) {
        if(claimContact === "Insured"){
          return "insured"
        }
        if(claimContact === "Claimant"){
          return "claimant"
        }
        if(claimContact === "Any Party Involved"){
          return "any"
        }
      }
    """
    * def nameSearchTypeCode = getNameSearchTypeCode(__arg.parameters.claimContact)
    * step('ClaimActions.SearchClaim', {'scenarioArgs': {'username': unrestrictedUsername, 'identifier': __arg.parameters.identifier}, 'templateArgs': {'nameSearchTypeCode': nameSearchTypeCode}})
    * __arg.cucumberDataCache.listOfClaims = getStepVariable('ClaimActions.SearchClaim','listOfClaims')