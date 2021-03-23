Feature: Incidents
  As an adjuster I want to perform actions on incidents

  Background:
    * def username = testDataContainer.getUser("ccadjuster1").getName()
    * def password = 'gw'
    * configure headers = read('classpath:headers.js')
    * def claimsUrl = ccBaseUrl + '/rest/claim/v1/claims'

  @id=CreateVehicleIncident
  Scenario: I create a vehicle incident with damage description {string}
    * def parameters = ['damageDescription']
    * def createAnIncidentTemplate = 'classpath:com/gw/cucumber/incidents/CreateVehicleIncident.json'
    * def vehicleIncidentUrl = claimsUrl +  "/" + __arg.cucumberDataCache.claimId + '/vehicle-incidents'
    * __arg.year = __arg.year != undefined ? parseInt(__arg.year, 10) : undefined
    * def requestPayload = readWithArgs(createAnIncidentTemplate, __arg)
    Given url vehicleIncidentUrl
    And request requestPayload
    When method POST
    Then status 201
    * match response.data.attributes.damageDescription == requestPayload.data.attributes.damageDescription
    * setStepVariable('incidentId', response.data.attributes.id)
    * setStepVariable('damageDescription', response.data.attributes.damageDescription)

  @id=CreateSomeVehicleIncidents
  Scenario: I create some vehicle incidents
    * def parameters = ['damageDescription']
    * def createAnIncidentTemplate = 'classpath:com/gw/cucumber/incidents/CreateVehicleIncident.json'
    * def vehicleIncidentUrl = claimsUrl +  "/" + __arg.cucumberDataCache.claimId + '/vehicle-incidents'
    * __arg.year = __arg.year != undefined ? parseInt(__arg.year, 10) : undefined
    * def requestPayload = readWithArgs(createAnIncidentTemplate, __arg)
    Given url vehicleIncidentUrl
    And request requestPayload
    When method POST
    Then status 201
    * match response.data.attributes.damageDescription == requestPayload.data.attributes.damageDescription
    * setStepVariable('incidentId', response.data.attributes.id)
    * setStepVariable('damageDescription', response.data.attributes.damageDescription)

  @id=GetVehicleIncident
  Scenario: the claim vehicle incident damage description is {string}
    * def parameters = ['damageDescription']
    * def getVehicleIncidentUrl = claimsUrl +  "/" + __arg.cucumberDataCache.claimId + '/vehicle-incidents/' + __arg.cucumberDataCache.incidentId
    Given url getVehicleIncidentUrl
    When method GET
    Then status 200
    * match response.data.attributes.damageDescription == __arg.parameters.damageDescription
    * eval if(__arg.vin != undefined) assertEqual(__arg.vin, response.data.attributes.vehicle.vin)
    * eval if(__arg.make != undefined) assertEqual(__arg.make, response.data.attributes.vehicle.make)
    * eval if(__arg.model != undefined) assertEqual(__arg.model, response.data.attributes.vehicle.model)
    * __arg.year = __arg.year != undefined ? parseInt(__arg.year, 10) : undefined
    * eval if(__arg.year != undefined) assertEqual(__arg.year, response.data.attributes.vehicle.year)
    * eval if(__arg.licensePlate != undefined) assertEqual(__arg.licensePlate, response.data.attributes.vehicle.licensePlate)
    * eval if(__arg.licensePlate != undefined) assertEqual(__arg.licensePlate, response.data.attributes.vehicle.licensePlate)
    * eval if(__arg.state != undefined) assertEqual(__arg.state, response.data.attributes.vehicle.state.code)
    * eval if(__arg.color != undefined) assertEqual(__arg.color, response.data.attributes.vehicle.color)

    @id=VerifyCucumberExpressionParameterTypeInJSONTemplate
    Scenario: I create a vehicle incident for the {string} on my {int} car
      * def parameters = ['damageDescription', 'year']
      * match __arg.year == 2010
      * def createAnIncidentTemplate = 'classpath:com/gw/cucumber/incidents/CreateVehicleIncident.json'
      * def vehicleIncidentUrl = claimsUrl +  "/" + __arg.cucumberDataCache.claimId + '/vehicle-incidents'
      * def requestPayload = readWithArgs(createAnIncidentTemplate, __arg)
      Given url vehicleIncidentUrl
      And request requestPayload
      When method POST
      Then status 201
      * match response.data.attributes.vehicle.year == __arg.year
      * match response.data.attributes.damageDescription == requestPayload.data.attributes.damageDescription
