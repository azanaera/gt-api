Feature: aaaPolicies
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
            return 'classpath:com/gw/apicomponents/policies/createCAPolicy.json';
          case 'CommercialProperty':
            return 'classpath:com/gw/apicomponents/policies/createCPPolicy.json';
          case 'Homeowners':
            return 'classpath:com/gw/apicomponents/policies/createHOPolicy.json';
          case 'PersonalAuto':
            return 'classpath:com/gw/apicomponents/policies/createPAPolicy.json';
          default:
           throw 'Unhandled line of business: ' + lineOfBusiness;
       }
     }
    """

    * def getIndexOfInsuredFromPolicyContacts =
    """
     function(contacts) {
        for(i=0;i<contacts.length;i++){
           if (contacts[i].roles[0].code=='insured'){
              return i;
           }
        }
        throw 'Unable to find contact with role - Insured on the policy';
     }
   """

  @id=CreatePolicy
  Scenario: Create a policy
    * def requiredScenarioArguments = ['lineOfBusiness']
    Given url policiesUrl
    And request readWithArgs(getCreatePolicyTemplateName(__arg.scenarioArgs.lineOfBusiness), __arg.templateArgs)
    When method POST
    Then status 201
    * setStepVariable('policyNumber', response.data.attributes.policyNumber)
    * def index = getIndexOfInsuredFromPolicyContacts(response.data.attributes.policyContacts)
    * setStepVariable('insured', response.data.attributes.policyContacts[index].contact.displayName)


