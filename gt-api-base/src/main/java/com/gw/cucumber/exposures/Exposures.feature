Feature: Exposures
  As an adjuster I want to perform actions on claim exposures

  Background:
    * def username = testDataContainer.getUser("ccadjuster1").getName()
    * def password = 'gw'
    * configure headers = read('classpath:headers.js')
    * def claimsUrl = ccBaseUrl + '/rest/claim/v1/claims'
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
  Scenario: I create an exposure on the claim vehicle incident
    * def createExposureTemplate = 'classpath:com/gw/cucumber/exposures/CreateExposureWithVehicleIncident.json'
    * def createExposureUrl = claimsUrl + "/" + __arg.cucumberDataCache.claimId + '/exposures'
    * def requestPayload = readWithArgs(createExposureTemplate, __arg)
    Given url createExposureUrl
    And request requestPayload
    When method POST
    Then status 201
    * match response.data.attributes.primaryCoverage.code == requestPayload.data.attributes.primaryCoverage.code
    * setStepVariable('exposureId', response.data.attributes.id)

  @id=CloseExposure
  Scenario: I close the claim exposure
    * def closeExposureTemplate = 'classpath:com/gw/cucumber/exposures/CloseExposure.json'
    * def closeExposureUrl = claimsUrl + "/" + __arg.cucumberDataCache.claimId + '/exposures/' + __arg.cucumberDataCache.exposureId + '/close'
    Given url closeExposureUrl
    And request read(closeExposureTemplate)
    When method POST
    Then status 200
    * match response.data.attributes.closedOutcome.code == "completed"

  @id=UpdateExposureJurisdiction
  Scenario: I update the claim exposure jurisdiction to be {string}
    * def parameters = ['jurisdictionCode']
    * def updateExposureTemplate = 'classpath:com/gw/cucumber/exposures/UpdateExposure.json'
    * def updateExposureUrl = claimsUrl + "/" + __arg.cucumberDataCache.claimId + '/exposures/' + __arg.cucumberDataCache.exposureId
    * def requestPayload = readWithArgs(updateExposureTemplate, __arg)
    Given url updateExposureUrl
    And request requestPayload
    When method PATCH
    Then status 200
    * match response.data.attributes.jurisdiction.code == requestPayload.data.attributes.jurisdiction.code

  @id=GetExposure
  Scenario: the claim exposure jurisdiction is {string}
    * def parameters = ['jurisdictionCode']
    * def getExposureUrl = claimsUrl + "/" + __arg.cucumberDataCache.claimId + '/exposures/' + __arg.cucumberDataCache.exposureId
    Given url getExposureUrl
    When method GET
    Then status 200
    * match response.data.attributes.jurisdiction.code == __arg.parameters.jurisdictionCode

