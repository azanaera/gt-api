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

  @id=GetClaim
  Scenario: Get the claim data
    * def requiredArguments = ['claimId']
    * def getClaimUrl = claimsUrl + "/" + __arg.scenarioArgs.claimId
    Given url getClaimUrl
    When method GET
    Then status 200
    * match response.data.attributes.insured.id == __arg.scenarioArgs.insuredId
    * setStepVariable('claimOwnerId', response.data.attributes.assignedUser.id)
    * setStepVariable('claimAssignedGroup', response.data.attributes.assignedGroup.displayName)

  @id=UpdateLossCause
  Scenario: Update Loss Cause
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
    * def submitClaimTemplate = sharedPath + 'submitClaimAutoAssign.json'
    * def claimSubmitUrl = claimsUrl +  "/" + __arg.scenarioArgs.draftClaimId + '/submit'
    Given url claimSubmitUrl
    And request read(submitClaimTemplate)
    When method POST
    Then status 200
    * match response.data.attributes.id ==  __arg.scenarioArgs.draftClaimId

  @id=MatchClaimAssignedGroup
  Scenario: Match assigned group of the claim
    * def requiredArguments = ['group', 'claimAssignedGroup']
    * match __arg.scenarioArgs.group == __arg.scenarioArgs.claimAssignedGroup

  @id=UpdateLossLocation
  Scenario: Update loss location of the claim
    * def requiredArguments = ['claimId']
    * def updateClaimUrl = claimsUrl + '/' + __arg.scenarioArgs.claimId
    * def updateLossLocationTemplate = sharedPath + 'updateLossLocation.json'
    Given url updateClaimUrl
    And request readWithArgs(updateLossLocationTemplate, __arg.templateArgs)
    When method PATCH
    Then status 200