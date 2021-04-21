Feature: Policy
  Action scenarios that operate on Policies

  Background:
    * def username = claimUtils.getUnrestrictedUser()
    * def password = claimsDataContainer.getPassword()
    * def policiesUrl = ccBaseUrl + '/rest/testsupport/v1/policies'
    * def policySearchUrl = ccBaseUrl + '/rest/testsupport/v1/search/policies'
    * configure headers = read('classpath:headers.js')
    * def sharedPath = 'classpath:com/gw/surepath/action/policy/'
    * def getCreatePolicyTemplateName =
    """
     function(lineOfBusiness) {
        switch(lineOfBusiness) {
          case 'PersonalAuto':
            return sharedPath + 'createPAPolicy.json';
          case 'Homeowners':
            return sharedPath + 'createHOPolicy.json';
          default:
           throw 'Unhandled line of business: ' + lineOfBusiness;
       }
     }
    """

  @id=CreatePolicy
  Scenario: Create a policy
    * def requiredArguments = ['lineOfBusiness']
    Given url policiesUrl
    And request readWithArgs(getCreatePolicyTemplateName(__arg.scenarioArgs.lineOfBusiness), __arg.templateArgs)
    When method POST
    Then status 201
    * setStepVariable('policyNumber', response.data.attributes.policyNumber)

  @id=CreateUnverifiedPolicy
  Scenario: Create an unverified policy
    Given url policiesUrl
    And request readWithArgs(sharedPath + 'createUnverifiedPolicy.json', __arg.templateArgs)
    When method POST
    Then status 201
    And match response.data.attributes.verifiedPolicy == false
    * setStepVariable('policyNumber', response.data.attributes.policyNumber)

  @id=MatchPolicyByPolicyNumber
  Scenario: Match a policy by policy number
    * def requiredArguments = ['listOfPolicyNumbers', 'policyNumber']
    * match __arg.scenarioArgs.listOfPolicyNumbers contains __arg.scenarioArgs.policyNumber

  #paging is not supported
  @id=SearchPolicy
  Scenario: Search policies with known policy information
    * def requiredArguments = ['policyInformation']
    * def getPolicySearchTemplate =
    """
      function(policyInformation) {
        switch(policyInformation) {
          case "Policy Number":
            return sharedPath + 'searchPolicyByPolicyNumber.json'
          case "Policy Type":
            return sharedPath + 'searchPolicyByPolicyType.json'
          case "State":
            return sharedPath + 'searchPolicyByState.json'
          case "ZIP Code":
            return sharedPath + 'searchPolicyByZipCode.json'
        }
      }
    """
    Given url policySearchUrl
    And request readWithArgs(getPolicySearchTemplate(__arg.scenarioArgs.policyInformation), __arg.templateArgs)
    When method POST
    Then status 200
    And assert response.count > 0
    * def listOfPolicyNumbers = karate.jsonPath(response, '$.data[*].attributes.policyNumber')
    * setStepVariable('listOfPolicyNumbers', listOfPolicyNumbers)