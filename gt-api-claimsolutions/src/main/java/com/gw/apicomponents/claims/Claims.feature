Feature: Claims
  As an adjuster I want to perform actions on claims

  Background:
    * def sharedPath = 'classpath:com/gw/apicomponents/claims/'
    * def getCreateClaimTemplateName =
"""
 function(lineOfBusiness) {
    switch(lineOfBusiness) {
      case 'CommercialAuto':
        return sharedPath + 'createCAClaim.json';
      case 'CommercialProperty':
        return sharedPath + 'createCPClaim.json';
      case 'Homeowners':
        return sharedPath + 'createHOClaim.json';
      case 'PersonalAuto':
        return sharedPath + 'createPAClaim.json';
      default:
       throw 'Unhandled line of business: ' + lineOfBusiness;
   }
 }
"""

  @id=CreateClaim
  Scenario: Create a claim
    * def requiredScenarioArguments = ['lineOfBusiness']
    Given url claimsUrl
    And request readWithArgs(getCreateClaimTemplateName(__arg.scenarioArgs.lineOfBusiness), __arg.templateArgs)
    When method POST
    Then status 201
    * setStepVariable('claimId', response.data.attributes.id)
    * setStepVariable('mainContactId', response.data.attributes.mainContact.id)
    * eval if(__arg.scenarioArgs.lineOfBusiness == 'CommercialAuto') setStepVariable('reporterId', response.data.attributes.reporter.id)


  @id=SubmitClaim
  Scenario: Submit a draft claim
    #Framework validation enforced only for requiredArguments
    * def requiredArguments = ['draftClaimId']
    * def submitClaimTemplate = sharedPath + 'submitClaim.json'
    * def claimsubmitUrl = claimsUrl +  "/" + __arg.scenarioArgs.draftClaimId + '/submit'
    Given url claimsubmitUrl
    And request readWithArgs(submitClaimTemplate, __arg.templateArgs)
    When method POST
    Then status 200
    * match response.data.attributes.id ==  __arg.scenarioArgs.draftClaimId
    * setStepVariable('insuredId', response.data.attributes.insured.id)

  @id=CloseClaim
  Scenario: Close an open claim
    * def requiredArguments = ['claimId']
    * def closeClaimTemplate = sharedPath + 'closeClaim.json'
    * def closeClaimUrl = claimsUrl +  "/" + __arg.scenarioArgs.claimId + '/close'
    Given url closeClaimUrl
    And request read(closeClaimTemplate)
    When method POST
    Then status 200
    * match response.data.attributes.closedOutcome.code == "completed"

  @id=GetClaim
  Scenario: Get the claim data
    * def requiredArguments = ['claimId']
    * def getClaimUrl = claimsUrl + "/" + __arg.scenarioArgs.claimId
    Given url getClaimUrl
    When method GET
    Then status 200
    * match response.data.attributes.insured.id == __arg.scenarioArgs.insuredId


  @id=GetClaimPolicy
  Scenario: Get Policy Associated with the Claim
    * def requiredArguments = ['claimId']
    * def claimPolicyUrl = claimsUrl + "/" + __arg.scenarioArgs.claimId + "/policy"
    Given url claimPolicyUrl
    When method GET
    Then status 200
    * match response.data.attributes.policyNumber ==  __arg.scenarioArgs.policyNumber
    * setStepVariable('policyId', response.data.attributes.id)
