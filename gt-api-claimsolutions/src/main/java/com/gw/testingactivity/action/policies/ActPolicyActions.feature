Feature: Policy
  Action scenarios that operate on Policies

  Background:
    * def username = claimUtils.getUnrestrictedUser()
    * def password = claimsDataContainer.getPassword()
    * def policiesUrl = ccBaseUrl + '/rest/testsupport/v1/policies'
    * def policySearchUrl = ccBaseUrl + '/rest/testsupport/v1/search/policies'
    * configure headers = read('classpath:headers.js')
    * def sharedPath = 'classpath:com/gw/testingactivity/action/policies/'
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