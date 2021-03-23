Feature: Claims
  As an adjuster I want to perform actions on claims

  Background:
    * def username = testDataContainer.getUser("ccadjuster1").getName()
    * def password = 'gw'
    * configure headers = read('classpath:headers.js')
    * def claimsUrl = ccBaseUrl + '/rest/claim/v1/claims'
    * def getCreateClaimTemplateName =
    """
     function(lineOfBusiness) {
        switch(lineOfBusiness) {
          case 'PersonalAuto':
            return 'classpath:com/gw/cucumber/claims/CreatePAClaim.json';
          default:
           throw 'Unhandled line of business: ' + lineOfBusiness;
       }
     }
    """

  @id=CreateClaim
  Scenario: I create a claim against that {string} policy
    * def parameters = ['lineOfBusiness']
    Given url claimsUrl
    And request readWithArgs(getCreateClaimTemplateName(__arg.parameters.lineOfBusiness), __arg)
    When method POST
    Then status 201
    * setStepVariable('claimId', response.data.attributes.id)
    * setStepVariable('mainContactId', response.data.attributes.mainContact.id)
    * eval if(__arg.parameters.lineOfBusiness == 'CommercialAuto') setStepVariable('reporterId', response.data.attributes.reporter.id)


  @id=SubmitClaim
  Scenario: I submit the claim
    * def submitClaimTemplate = 'classpath:com/gw/cucumber/claims/submitClaim.json'
    * def claimsubmitUrl = claimsUrl +  "/" + __arg.cucumberDataCache.claimId + '/submit'
    Given url claimsubmitUrl
    And request readWithArgs(submitClaimTemplate, __arg)
    When method POST
    Then status 200
    * match response.data.attributes.id ==  __arg.cucumberDataCache.claimId
    * setStepVariable('insuredId', response.data.attributes.insured.id)

  @id=CloseClaim
  Scenario: I close the claim
    * def closeClaimTemplate = 'classpath:com/gw/cucumber/claims/closeClaim.json'
    * def closeClaimUrl = claimsUrl +  "/" + __arg.cucumberDataCache.claimId + '/close'
    Given url closeClaimUrl
    And request read(closeClaimTemplate)
    When method POST
    Then status 200
    * match response.data.attributes.closedOutcome.code == "completed"

  @id=GetClaim
  Scenario: I find the claim
    * def getClaimUrl = claimsUrl + "/" + __arg.cucumberDataCache.claimId
    Given url getClaimUrl
    When method GET
    Then status 200
    * match response.data.attributes.insured.id == __arg.cucumberDataCache.insuredId



