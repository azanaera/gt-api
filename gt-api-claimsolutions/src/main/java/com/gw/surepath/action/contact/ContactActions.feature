Feature: Contact
  As an adjuster I want to perform actions on contacts

  Background:
    * def username = __arg.scenarioArgs.username
    * def password = claimsDataContainer.getPassword()
    * def claimsUrl = ccBaseUrl + '/rest/claim/v1/claims'
    * configure headers = read('classpath:headers.js')

  @id=GetInsuredPrimaryAddress
  Scenario: Get insured's primary address
    * def requiredArguments = ['claimId', 'insuredId']
    * def getContactUrl = claimsUrl + "/" + __arg.scenarioArgs.claimId + "/contacts/" + __arg.scenarioArgs.insuredId
    Given url getContactUrl
    When method GET
    Then status 200
    * setStepVariable('primaryAddress', response.data.attributes.primaryAddress)