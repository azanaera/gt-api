Feature: Exposures
  As an adjuster I want to perform actions on claim exposures

  Background:
    * def username = claimusername
    * def password = claimpassword
    * configure headers = read('classpath:headers.js')
    * def closeExposure =
   """
   function(exposureList, claimId) {
     for (var key in exposureList) {
            var exposureId = exposureList[key];
            step('Exposures.CloseExposure', {'scenarioArgs': {'claimId': claimId, 'exposureId': exposureId}});
     }
   }
   """

  @id=CreateVehicleIncidentExposure 
  Scenario: Create an exposure with Vehicle Incident
    * def requiredArguments = ['claimId']
    * def createExposureTemplate = 'classpath:com/gw/apicomponents/cc/exposures/createExposureWithVehicleIncident.json'
    * def createExposureUrl = claimsUrl + "/" + __arg.scenarioArgs.claimId + '/exposures'
    Given url createExposureUrl
    And request readWithArgs(createExposureTemplate, __arg.templateArgs)
    When method POST
    Then status 201
    * match response.data.attributes.primaryCoverage.code == "PACollisionCov"
    * setStepVariable('exposureId', response.data.attributes.id)

  @id=CloseExposure
  Scenario: close the exposure
    * def requiredArguments = ['claimId','exposureId']
    * def closeExposureTemplate = 'classpath:com/gw/apicomponents/cc/exposures/closeExposure.json'
    * def closeExposureUrl = claimsUrl + "/" + __arg.scenarioArgs.claimId + '/exposures/' + __arg.scenarioArgs.exposureId + '/close'
    Given url closeExposureUrl
    And request read(closeExposureTemplate)
    When method POST
    Then status 200
    * match response.data.attributes.closedOutcome.code == "completed"

  @id=UpdateExposureJurisdiction
  Scenario: update the jurisdiction code in exposure
    * def requiredArguments = ['claimId','exposureId']
    * def updateExposureTemplate = 'classpath:com/gw/apicomponents/cc/exposures/updateExposure.json'
    * def updateExposureUrl = claimsUrl + "/" + __arg.scenarioArgs.claimId + '/exposures/' + __arg.scenarioArgs.exposureId
    Given url updateExposureUrl
    And request readWithArgs(updateExposureTemplate, __arg.templateArgs)
    When method PATCH
    Then status 200
    * match response.data.attributes.jurisdiction.code == __arg.templateArgs.jurisdictionCode

  @id=GetExposure
  Scenario: get the exposure data
    * def requiredArguments = ['claimId','exposureId']
    * def getExposureUrl = claimsUrl + "/" + __arg.scenarioArgs.claimId + '/exposures/' + __arg.scenarioArgs.exposureId
    Given url getExposureUrl
    When method GET
    Then status 200
    * match response.data.attributes.jurisdiction.code == __arg.scenarioArgs.jurisdictionCode

  @id=CreateBuildingCoverageExposure
  Scenario: Create a BuildingCoverage exposure
    * def requiredArguments = ['claimId']
    * def createCPExposureTemplate = 'classpath:com/gw/apicomponents/cc/exposures/createExposureWithBuildingCoverage.json'
    * def createExposureUrl = claimsUrl + "/" + __arg.scenarioArgs.claimId + '/exposures'
    Given url createExposureUrl
    And request readWithArgs(createCPExposureTemplate, __arg.templateArgs)
    When method POST
    Then status 201
    * match response.data.attributes.primaryCoverage.code == "CPBldgCov"
    * setStepVariable('exposureId', response.data.attributes.id)

 # close all exposures - some got created by a business rule
  @id=CloseExposures
  Scenario: get the list of exposures and close all
    * def requiredArguments = ['claimId']
    * def listOfExposuresUrl = claimsUrl +  "/" + __arg.scenarioArgs.claimId + '/exposures'
    Given url listOfExposuresUrl
    When method GET
    Then status 200
    * def listofIds = karate.jsonPath(response, '$.data[*].attributes.id')
    * def result = call closeExposure(listofIds,__arg.scenarioArgs.claimId)

    @id=CreateExposureWithDwellingIncident
  Scenario: Create an exposure with Dwelling incident
    * def requiredArguments = ['claimId']
    * def createDwellingIncidentExposureUrl = claimsUrl + "/" + __arg.scenarioArgs.claimId + '/exposures'
    * def createExposureWithDwellingIncidentTemplate = 'classpath:com/gw/apicomponents/cc/exposurescreateExposureWithDwellingIncident.json'
    Given url createDwellingIncidentExposureUrl
    And request readWithArgs(createExposureWithDwellingIncidentTemplate, __arg.templateArgs)
    When method POST
    Then status 201
    * match response.data.attributes.primaryCoverage.code == "zl4i2neakg3g4ecg0t01bj445va"
      # coverage - For Coverage A - Dwelling
    * setStepVariable('exposureOfDwellingId', response.data.attributes.id)

   @id=CreateExposureWithLivingExpensesIncident
  Scenario: Create an exposure with Living Expenses incident
    * def requiredArguments = ['claimId']
    * def createLivingExpensesIncidentExposureUrl = claimsUrl + "/" + __arg.scenarioArgs.claimId + '/exposures'
    * def createExposureWithLivingExpensesIncidentTemplate = 'classpath:com/gw/apicomponents/cc/exposurescreateExposureWithLivingExpensesIncident.json'
    Given url createLivingExpensesIncidentExposureUrl
    And request readWithArgs(createExposureWithLivingExpensesIncidentTemplate, __arg.templateArgs)
    When method POST
    Then status 201
    * match response.data.attributes.primaryCoverage.code == "zpsii9qu58bma5eju8f5pgi0brb"
    # coverage - For Coverage D - Loss of Use
    * setStepVariable('exposureOfLivingExpensesId', response.data.attributes.id)

  @id=UpdateClaimantOnExposure
  Scenario: Update claimant on Exposure to the new contact
    * def requiredArguments = ['claimId', 'exposureOfDwellingId']
    * def updateExposureWithClaimantUrl = claimsUrl + "/" + __arg.scenarioArgs.claimId + '/exposures/' + __arg.scenarioArgs.exposureOfDwellingId
    * def updateExposureWithClaimantTemplate = 'classpath:com/gw/apicomponents/cc/exposures/updateClaimantOnExposure.json'
    Given url updateExposureWithClaimantUrl
    And request readWithArgs(updateExposureWithClaimantTemplate, __arg.templateArgs)
    When method PATCH
    Then status 200
    * match response.data.attributes.claimant.id == __arg.templateArgs.mainContactId

  @id=CreateInjuryIncidentExposure
  Scenario: Create an exposure with bodily injury incident
    * def requiredArguments = ['claimId']
    * def createExposureTemplate = 'classpath:com/gw/apicomponents/cc/exposures/createExposureWithBodilyInjuryIncident.json'
    * def createExposureUrl = claimsUrl + "/" + __arg.scenarioArgs.claimId + '/exposures'
    Given url createExposureUrl
    And request readWithArgs(createExposureTemplate, __arg.templateArgs)
    When method POST
    Then status 201
    * match response.data.attributes.primaryCoverage.code == "PAUMBICov"
    * setStepVariable('exposureId', response.data.attributes.id)

