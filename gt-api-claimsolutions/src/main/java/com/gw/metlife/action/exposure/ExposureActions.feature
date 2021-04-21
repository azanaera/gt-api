Feature: Exposure
  Action scenarios that operate on Claim Exposures

  Background:
    * def username = __arg.scenarioArgs.username
    * def password = claimsDataContainer.getPassword()
    * def claimsUrl = ccBaseUrl + '/rest/claim/v1/claims'
    * configure headers = read('classpath:headers.js')
    * def sharedPath = 'classpath:com/gw/surepath/action/exposure/'

  @id=CreateVehicleIncidentExposure
  Scenario: Create an exposure with vehicle incident
    * def requiredArguments = ['claimId', 'vehicleIncidentType']
    * def createExposureUrl = claimsUrl + "/" + __arg.scenarioArgs.claimId + '/exposures'
    * def getCreateExposureTemplate =
    """
      function(vehicleIncidentType) {
        if (vehicleIncidentType == 'withAttributes') {
          return sharedPath + 'createWithAttributesVehicleIncidentExposure.json'
        }
        else if (vehicleIncidentType == 'insured' || vehicleIncidentType == 'totalLossInsured') {
          return sharedPath + 'createInsuredVehicleIncidentExposure.json'
        }
        else if (vehicleIncidentType == 'third-party') {
          return sharedPath + 'createThirdPartyVehicleIncidentExposure.json'
        }
      }
    """
    * def createExposureTemplate = getCreateExposureTemplate(__arg.scenarioArgs.vehicleIncidentType)
    Given url createExposureUrl
    And request readWithArgs(createExposureTemplate, __arg.templateArgs)
    When method POST
    Then status 201
    * setStepVariable('exposureId', response.data.attributes.id)

  @id=CreateInjuryIncidentExposure
  Scenario: Create an exposure with bodily injury incident
    * def requiredArguments = ['claimId']
    * def createExposureTemplate = sharedPath + 'createInjuryIncidentExposure.json'
    * def createExposureUrl = claimsUrl + "/" + __arg.scenarioArgs.claimId + '/exposures'
    Given url createExposureUrl
    And request readWithArgs(createExposureTemplate, __arg.templateArgs)
    When method POST
    Then status 201
    * setStepVariable('exposureId', response.data.attributes.id)

  @id=GetExposure
  Scenario: Get the exposure data
    * def requiredArguments = ['claimId', 'exposureId']
    * def getExposureUrl = claimsUrl + "/" + __arg.scenarioArgs.claimId + '/exposures/' + __arg.scenarioArgs.exposureId
    Given url getExposureUrl
    When method GET
    Then status 200
    * setStepVariable('exposureOwnerId', response.data.attributes.assignedUser.id)

  @id=GetExposureByCovSubtype
  Scenario: Get exposure by coverage subtype
    * def requiredArguments = ['claimId', 'coverageSubtype']
    * def exposuresUrl = claimsUrl +  "/" + __arg.scenarioArgs.claimId + '/exposures'
    Given url exposuresUrl
    When method GET
    Then status 200
    * match response.data[*].attributes.coverageSubtype.name contains __arg.scenarioArgs.coverageSubtype

  @id=GetExposureSegment
  Scenario: Get exposure segmentation
    * def requiredArguments = ['claimId', 'exposureId', 'exposureSegment']
    Given url claimsUrl + '/' + __arg.scenarioArgs.claimId + '/exposures/' + __arg.scenarioArgs.exposureId
    When method GET
    Then status 200
    And match response.data.attributes.segment.name == __arg.scenarioArgs.exposureSegment

  @id=MatchExposureOwnerWithClaimOwner
  Scenario: Match exposure owner with claim owner
    * def requiredArguments = ['exposureOwnerId', 'claimOwnerId']
    * match __arg.scenarioArgs.exposureOwnerId == __arg.scenarioArgs.claimOwnerId