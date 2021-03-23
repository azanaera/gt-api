Feature: Reserves
  As an adjuster I want to perform actions on claim reserves

  @id=CreateReserveForClaim
  Scenario:  add a reserve set to a claim
    * def requiredArguments = ['claimId']
    * def addReserveSetUrl = claimsUrl + '/' + __arg.scenarioArgs.claimId + '/reserve-sets'
    * def createReserveSetForClaimTemplate = 'classpath:com/gw/apicomponents/reserves/createReserveSetForClaim.json'
    Given url addReserveSetUrl
    And request readWithArgs(createReserveSetForClaimTemplate, __arg.templateArgs)
    When method POST
    Then status 201
    And match response.data.attributes.reserves[*].lineItems[*].reservingAmount.amount contains __arg.templateArgs.amount

  @id=CreateReserveForExposure
  Scenario: add a reserve set to a claim's Exposure
    * def requiredArguments = ['claimId']
    * def addReserveSetForExposureUrl = claimsUrl + '/' + __arg.scenarioArgs.claimId + '/reserve-sets'
    * def createReserveSetForExposureTemplate = 'classpath:com/gw/apicomponents/reserves/createReserveSetForExposure.json'
    Given url addReserveSetForExposureUrl
    And request readWithArgs(createReserveSetForExposureTemplate, __arg.templateArgs)
    When method POST
    Then status 201
    And match response.data.attributes.reserves[*].lineItems[*].reservingAmount.amount contains __arg.templateArgs.amount