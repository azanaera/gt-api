Feature: Policies
  As a superuser I want to create LOB policies

  Background:
    * def username = 'su'
    * def password = 'gw'
    * def policiesUrl = ccBaseUrl + '/rest/testsupport/v1/policies'
    * configure headers = read('classpath:headers.js')
    * def getCreatePolicyTemplateName =
    """
     function(lineOfBusiness) {
        switch(lineOfBusiness) {
          case 'CommercialAuto':
            return 'classpath:com/gw/cucumber/policies/createCAPolicy.json';
          case 'Homeowners':
            return 'classpath:com/gw/cucumber/policies/createHOPolicy.json';
          case 'PersonalAuto':
            return 'classpath:com/gw/cucumber/policies/CreatePAPolicy.json';
          default:
           throw 'Unhandled line of business: ' + lineOfBusiness;
       }
     }
    """

  @id=CreatePolicy
  Scenario: a {string} policy;I create a {string} policy;I have a {string} policy
    * def parameters = ['lineOfBusiness']
    Given url policiesUrl
    And request readWithArgs(getCreatePolicyTemplateName(__arg.parameters.lineOfBusiness), __arg)
    When method POST
    Then status 201
    * setStepVariable('policyNumber', response.data.attributes.policyNumber)

  @id=CreatePersonalAutoPolicy
  Scenario: a PersonalAuto policy
    Given url policiesUrl
    And request readWithArgs(getCreatePolicyTemplateName('PersonalAuto'), __arg)
    When method POST
    Then status 201
    * setStepVariable('policyNumber', response.data.attributes.policyNumber)

  @id=CreatePolicies
  Scenario: I create policies
    * def parameters = ['lineOfBusiness']
    Given url policiesUrl
    And request readWithArgs(getCreatePolicyTemplateName(__arg.parameters.lineOfBusiness), __arg)
    When method POST
    Then status 201
    * setStepVariable('policyNumber', response.data.attributes.policyNumber)

  @id=VerifyStringParameterType
  Scenario: I have to subscribe to a {string} policy
    * def parameters = ['policyType']
    * match __arg.parameters.policyType == 'HomeOwners'

  @id=VerifyParametersValuesNotMixedWithStepText
  Scenario: I have a {string} policy for my PersonalAuto and I can open a {string} Claim when my PersonalAuto is in an accident
    * def parameters = ['lineOfBusiness1', 'lineOfBusiness2']
    Given url policiesUrl
    And request readWithArgs(getCreatePolicyTemplateName(__arg.parameters.lineOfBusiness1), __arg)
    When method POST
    Then status 201
    * match __arg.parameters.lineOfBusiness2 == 'PersonalAuto'

  @id=VerifyUserDefinedParameterType
  Scenario: my personal auto policy total cost is {double} {sampleCurrencyUserDefinedType}
    * def parameters = ['amount', 'currency']
    * match __arg.parameters.currency == 'USD'

  @id=VerifyIntParameterType
  Scenario: I have {int} policies
    * def parameters = ['numberOfPolicies']
    * match __arg.parameters.numberOfPolicies == 5

  @id=VerifyDoubleParameterType
  Scenario: my personal auto policy total cost decreases by {double}
    * def parameters = ['totalCost']
    * match __arg.parameters.totalCost ==  -355.258

