Feature: Incident
  Action scenarios that operate on Claim Incidents

  Background:
    * def username = __arg.scenarioArgs.username
    * def password = claimsDataContainer.getPassword()
    * def claimsUrl = ccBaseUrl + '/rest/claim/v1/claims'
    * configure headers = read('classpath:headers.js')
    * def sharedPath = 'classpath:com/gw/surepath/action/incident/'

  @id=CreateInsuredVehicleIncident
  Scenario: Create an insured vehicle incident
    * def requiredArguments = ['claimId']
    * def createAnIncidentTemplate = sharedPath + 'createInsuredVehicleIncident.json'
    * def vehicleIncidentUrl = claimsUrl +  "/" + __arg.scenarioArgs.claimId + '/vehicle-incidents'
    Given url vehicleIncidentUrl
    And request readWithArgs(createAnIncidentTemplate, __arg.templateArgs)
    When method POST
    Then status 201
    * setStepVariable('incidentId', response.data.attributes.id)
    * setStepVariable('damageDescription', response.data.attributes.damageDescription)

  @id=UpdateVehicleIncidentTotalLoss
  Scenario: Update vehicle incident to total loss
    * def requiredArguments = ['claimId', 'incidentId']
    * def VehicleIncidentTotalLossTemplate = sharedPath + 'updateVehicleIncidentTotalLoss.json'
    * def vehicleIncidentUrl = claimsUrl +  "/" + __arg.scenarioArgs.claimId + '/vehicle-incidents/' + __arg.scenarioArgs.incidentId
    Given url vehicleIncidentUrl
    And request read(VehicleIncidentTotalLossTemplate)
    When method PATCH
    Then status 200