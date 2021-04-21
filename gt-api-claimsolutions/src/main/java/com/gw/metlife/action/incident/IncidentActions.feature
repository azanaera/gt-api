Feature: Incident
  Action scenarios that operate on Claim Incidents

  Background:
    * def username = __arg.scenarioArgs.username
    * def password = claimsDataContainer.getPassword()
    * def claimsUrl = ccBaseUrl + '/rest/claim/v1/claims'
    * configure headers = read('classpath:headers.js')
    * def sharedPath = 'classpath:com/gw/surepath/action/incident/'

  @id=CreateVehicleIncident
  Scenario: Create a vehicle incident
    * def requiredArguments = ['claimId', 'vehicleIncidentType']
    * def vehicleIncidentUrl = claimsUrl +  "/" + __arg.scenarioArgs.claimId + '/vehicle-incidents'
    * def getCreateIncidentTemplate =
    """
      function(vehicleIncidentType) {
        if (vehicleIncidentType == 'withAttributes') {
          return sharedPath + 'createWithAttributesVehicleIncident.json'
        }
        else if (vehicleIncidentType == 'insured') {
          return sharedPath + 'createInsuredVehicleIncident.json'
        }
        else if (vehicleIncidentType == 'totalLossInsured') {
          return sharedPath + 'createTotalLossInsuredVehicleIncident.json'
        }
        else if (vehicleIncidentType == 'third-party') {
          return sharedPath + 'createThirdPartyVehicleIncident.json'
        }
      }
    """
    * def createAnIncidentTemplate = getCreateIncidentTemplate(__arg.scenarioArgs.vehicleIncidentType)
    Given url vehicleIncidentUrl
    And request readWithArgs(createAnIncidentTemplate, __arg.templateArgs)
    When method POST
    Then status 201
    * setStepVariable('vehicleIncidentId', response.data.attributes.id)

  @id=CreateInjuryIncident
  Scenario: Create an injury incident
    * def requiredArguments = ['claimId', 'injuryIncidentType']
    * def injuryIncidentUrl = claimsUrl +  "/" + __arg.scenarioArgs.claimId + '/injury-incidents'
    * def getCreateIncidentTemplate =
    """
      function(injuryIncidentType) {
        if (injuryIncidentType == 'minor') {
          return sharedPath + 'createMinorInjuryIncident.json'
        }
        else if (injuryIncidentType == 'fatal') {
          return sharedPath + 'createFatalInjuryIncident.json'
        }
      }
    """
    * def createInjuryIncidentTemplate = getCreateIncidentTemplate(__arg.scenarioArgs.injuryIncidentType)
    Given url injuryIncidentUrl
    And request readWithArgs(createInjuryIncidentTemplate, __arg.templateArgs)
    When method POST
    Then status 201
    * setStepVariable('injuryIncidentId', response.data.attributes.id)

  @id=UpdateVehicleIncidentTotalLoss
  Scenario: Update vehicle incident to total loss
    * def requiredArguments = ['claimId', 'incidentId']
    * def VehicleIncidentTotalLossTemplate = sharedPath + 'updateVehicleIncidentTotalLoss.json'
    * def vehicleIncidentUrl = claimsUrl +  "/" + __arg.scenarioArgs.claimId + '/vehicle-incidents/' + __arg.scenarioArgs.incidentId
    Given url vehicleIncidentUrl
    And request read(VehicleIncidentTotalLossTemplate)
    When method PATCH
    Then status 200