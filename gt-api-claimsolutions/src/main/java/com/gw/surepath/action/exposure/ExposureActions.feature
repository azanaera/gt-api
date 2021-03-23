Feature: Exposure
  Action scenarios that operate on Claim Exposures

  Background:
    * def username = __arg.scenarioArgs.username
    * def password = claimsDataContainer.getPassword()
    * def claimsUrl = ccBaseUrl + '/rest/claim/v1/claims'
    * configure headers = read('classpath:headers.js')

  @id=GetExposure
  Scenario: Get the exposure data
    * def requiredArguments = ['claimId','exposureId']
    * def getExposureUrl = claimsUrl + "/" + __arg.scenarioArgs.claimId + '/exposures/' + __arg.scenarioArgs.exposureId
    Given url getExposureUrl
    When method GET
    Then status 200
    * setStepVariable('exposureOwnerId', response.data.attributes.assignedUser.id)

  @id=CreateVehicleIncidentExposure
  Scenario: Create an exposure with Vehicle Incident
    * def requiredArguments = ['claimId']
    * def createExposureTemplate = 'classpath:com/gw/surepath/action/exposure/createExposureWithVehicleIncident.json'
    * def createExposureUrl = claimsUrl + "/" + __arg.scenarioArgs.claimId + '/exposures'
    Given url createExposureUrl
    And request readWithArgs(createExposureTemplate, __arg.templateArgs)
    When method POST
    Then status 201
    * setStepVariable('exposureId', response.data.attributes.id)

  @id=MatchExposureOwnerWithClaimOwner
  Scenario: Match exposure owner with claim owner
    * def requiredArguments = ['exposureOwnerId', 'claimOwnerId']
    * match __arg.scenarioArgs.exposureOwnerId == __arg.scenarioArgs.claimOwnerId

  @id=GetExposureByCovSubtype
  Scenario: Get Exposure by Coverage Subtype
    * def requiredArguments = ['claimId', 'coverageSubtype']
    * def exposuresUrl = claimsUrl +  "/" + __arg.scenarioArgs.claimId + '/exposures'
    Given url exposuresUrl
    When method GET
    Then status 200
    * match response.data[*].attributes.coverageSubtype.name contains __arg.scenarioArgs.coverageSubtype