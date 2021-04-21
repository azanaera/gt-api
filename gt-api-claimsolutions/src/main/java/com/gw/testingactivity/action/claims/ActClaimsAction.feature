Feature: Claim
  Action scenarios that operate on Claims

  Background:
    * def username = __arg.scenarioArgs.username
    * def password = claimsDataContainer.getPassword()
    * def claimsUrl = ccBaseUrl + '/rest/claim/v1/claims'
    * configure headers = read('classpath:headers.js')
    * def sharedPath = 'classpath:com/gw/testingactivity/action/claims/'
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