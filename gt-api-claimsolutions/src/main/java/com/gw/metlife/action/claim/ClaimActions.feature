Feature: Claim
  Action scenarios that operate on Claims

  Background:
    * def username = __arg.scenarioArgs.username
    * def password = claimsDataContainer.getPassword()
    * def claimsUrl = ccBaseUrl + '/rest/claim/v1/claims'
    * configure headers = read('classpath:headers.js')
    * def sharedPath = 'classpath:com/gw/surepath/action/claim/'
    * def getCreateClaimTemplateName =
      """
       function(lineOfBusiness) {
          switch(lineOfBusiness) {
            case 'PersonalAuto':
              return sharedPath + 'createPAClaim.json';
            case 'Homeowners':
              return sharedPath + 'createHOClaim.json';
            default:
             throw 'Unhandled line of business: ' + lineOfBusiness;
         }
       }
      """

  @id=CreateClaim
  Scenario: Create a claim
    * def requiredArguments = ['lineOfBusiness']
    Given url claimsUrl
    And request readWithArgs(getCreateClaimTemplateName(__arg.scenarioArgs.lineOfBusiness), __arg.templateArgs)
    When method POST
    Then status 201
    * setStepVariable('claimId', response.data.attributes.id)
    * setStepVariable('insuredId', response.data.attributes.insured.id)

  @id=UpdateLossCause
  Scenario: Update loss cause
    * def requiredArguments = ['claimId']
    * def updateClaimUrl = claimsUrl + '/' + __arg.scenarioArgs.claimId
    * def updateLossCauseTemplate = sharedPath + 'updateLossCause.json'
    Given url updateClaimUrl
    And request readWithArgs(updateLossCauseTemplate, __arg.templateArgs)
    When method PATCH
    Then status 200

  @id=SubmitClaimAndAutoAssign
  Scenario: Submit a draft claim and assign it automatically
    * def requiredArguments = ['draftClaimId']
    * def submitClaimTemplate = 'classpath:com/gw/apicomponents/EmptyRequest.json'
    * def claimSubmitUrl = claimsUrl +  "/" + __arg.scenarioArgs.draftClaimId + '/submit'
    Given url claimSubmitUrl
    And request read(submitClaimTemplate)
    When method POST
    Then status 200
    * match response.data.attributes.id ==  __arg.scenarioArgs.draftClaimId
    * setStepVariable('claimOwnerId', response.data.attributes.assignedUser.id)
    * setStepVariable('claimAssignedGroup', response.data.attributes.assignedGroup.displayName)
    * setStepVariable('claimNumber', response.data.attributes.claimNumber)

  @id=MatchClaimAssignedGroup
  Scenario: Match assigned group of the claim
    * def requiredArguments = ['group', 'claimAssignedGroup']
    * match __arg.scenarioArgs.group == __arg.scenarioArgs.claimAssignedGroup

  @id=UpdateLossLocation
  Scenario: Update loss location of the claim
    * def requiredArguments = ['claimId']
    * def updateClaimUrl = claimsUrl + '/' + __arg.scenarioArgs.claimId
    * def getUpdateLossLocationTemplate =
    """
      function(templateArgs){
        if(templateArgs.city !== undefined && templateArgs.state !== undefined){
          return sharedPath + 'updateLossLocation.json'
        }
        if(templateArgs.lossLocationId !== undefined){
          return sharedPath + 'patchClaimLossLocationWithPolicyAddress.json'
        }
      }
    """
    Given url updateClaimUrl
    And request readWithArgs(getUpdateLossLocationTemplate(__arg.templateArgs), __arg.templateArgs)
    When method PATCH
    Then status 200
    * setStepVariable('insuredId', response.data.attributes.insured.id)

  @id=GetClaimSegment
  Scenario: Get claim segmentation
    * def requiredArguments = ['claimId', 'claimSegment']
    Given url claimsUrl + '/' + __arg.scenarioArgs.claimId
    When method GET
    Then status 200
    And match response.data.attributes.segment.name == __arg.scenarioArgs.claimSegment

  @id=CreateMinimalDraftClaim
  Scenario: Create a minimal draft claim
    Given url claimsUrl
    And request readWithArgs(sharedPath + 'createMinimalClaim.json', __arg.templateArgs)
    When method POST
    Then status 201
    * setStepVariable('claimId', response.data.attributes.id)
    * setStepVariable('insuredId', response.data.attributes.insured.id)

  @id=UpdateClaimReportedByInsured
  Scenario: Update claim reported by insured
    * def requiredArguments = ['claimId']
    Given url claimsUrl + '/' + __arg.scenarioArgs.claimId
    And request readWithArgs(sharedPath + 'patchClaimReportedByInsured.json', __arg.templateArgs)
    When method PATCH
    Then status 200

  @id=SearchClaim
  Scenario: Search for a claim
    * def requiredArguments = ['identifier']
    * def getSearchClaimTemplate =
    """
      function(identifier){
        if(identifier === 'Claim Number'){
          return sharedPath + 'searchClaimByClaimNumber.json';
        }
        if(identifier === 'Policy Number'){
          return sharedPath + 'searchClaimByPolicyNumber.json';
        }
        if(identifier === "First Name"){
          return sharedPath + 'searchClaimByContactFirstName.json';
        }
        if(identifier === "Last Name"){
          return sharedPath + 'searchClaimByContactLastName.json';
        }
      }
    """
    Given url ccBaseUrl + '/rest/claim/v1/search/claims'
    And request readWithArgs(getSearchClaimTemplate(__arg.scenarioArgs.identifier), __arg.templateArgs)
    When method POST
    Then status 200
    And assert response.count > 0
    * def listOfClaims = karate.jsonPath(response, '$.data[*].attributes.claimId')
    * setStepVariable('listOfClaims', listOfClaims)

  @id=MatchClaimByClaimId
  Scenario: Match a claim by claim id
    * def requiredArguments = ['listOfClaims', 'claimId']
    * match __arg.scenarioArgs.listOfClaims contains __arg.scenarioArgs.claimId