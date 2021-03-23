Feature: Accounts

  Background:
    * def username = policyDataContainer.getPolicyUser(__arg.cucumberDataCache.currentUserRole).getName()
    * def password = 'gw'
    * configure headers = read('classpath:headers.js')
    * def accountsUrl = pcBaseUrl + '/rest/account/v1/accounts'
    * def adminInputDataFile = 'classpath:com/gw/datacreation/admindata/policyAdminData.json'
    * def getCreateAccountTemplateName =
    """
     function(accountType) {
     
        switch(accountType) {
          case 'Person':
            return 'classpath:com/gw/surepath/apicomponents/account/addPersonAccount.json';
          case 'Company':
            return 'classpath:com/gw/surepath/apicomponents/account/addCompanyAccount.json';
          default:
           throw 'Unhandled Account Type: ' + accountType;
       }
     }
    """
  @id=AddAccount
  Scenario: an account exists with the following details
    * def parameters = ['AccountType', 'State']
    * def userProducerCode = call read('classpath:user-config.js') currentUserRole
    Given url accountsUrl
    And request readWithArgs(getCreateAccountTemplateName(__arg.parameters.AccountType), karate.merge(__arg.parameters, {'producerCodeId': userProducerCode}))
    When method POST
    Then status 201
    * setStepVariable('accountId', response.data.attributes.id)
    * setStepVariable('accountNumber', response.data.attributes.accountNumber)


