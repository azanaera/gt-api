Feature: Incidents
  As an adjuster I want to perform actions on incidents

  @id=CreateVehicleIncident
  Scenario: create an incident
    * def requiredArguments = ['claimId']
    * def createAnIncidentTemplate = 'classpath:com/gw/apicomponents/incidents/createVehicleIncident.json'
    * def vehicleIncidentUrl = claimsUrl +  "/" + __arg.scenarioArgs.claimId + '/vehicle-incidents'
    Given url vehicleIncidentUrl
    And request readWithArgs(createAnIncidentTemplate, __arg.templateArgs)
    When method POST
    Then status 201
    * match response.data.attributes.damageDescription == "Damaged front bumper"
    * setStepVariable('incidentId', response.data.attributes.id)
    * setStepVariable('damageDescription', response.data.attributes.damageDescription)

  @id=GetVehicleIncident
  Scenario: Get vehicle incident details
    * def requiredArguments = ['claimId','incidentId']
    * def getVehicleIncidentUrl = claimsUrl +  "/" + __arg.scenarioArgs.claimId + '/vehicle-incidents/' + __arg.scenarioArgs.incidentId
    Given url getVehicleIncidentUrl
    When method GET
    Then status 200
    * match response.data.attributes.damageDescription == __arg.scenarioArgs.damageDescription

  @id=CreateFixedPropertyIncident
  Scenario: create a fixed property incident
    * def requiredArguments = ['claimId']
    * def createFixedPropertyIncidentTemplate = 'classpath:com/gw/apicomponents/incidents/createFixedPropertyVehicleIncident.json'
    * def fixedPropertyIncidentUrl = claimsUrl +  "/" + __arg.scenarioArgs.claimId + '/fixed-property-incidents'
    Given url fixedPropertyIncidentUrl
    And request readWithArgs(createFixedPropertyIncidentTemplate, __arg.templateArgs)
    When method POST
    Then status 201
    * match response.data.attributes.description == "Fixed Property incident"
    * setStepVariable('incidentId', response.data.attributes.id)

  @id=CreateDwellingIncident
  Scenario: create a dwelling incident
    * def requiredArguments = ['claimId']
    * def dwellingIncidentUrl = claimsUrl +  "/" + __arg.scenarioArgs.claimId + '/dwelling-incidents'
    * def createDwellingIncidentTemplate = 'classpath:com/gw/apicomponents/incidents/createDwellingIncident.json'
    Given url dwellingIncidentUrl
    And request read(createDwellingIncidentTemplate)
    When method POST
    Then status 201
    * match response.data.attributes.description == "Dwelling damaged by explosion"
    * setStepVariable('dwellingIncidentId', response.data.attributes.id)

  @id=CreateInjuryIncident
  Scenario: create a bodily injury incident
    * def requiredArguments = ['claimId']
    * def injuryIncidentUrl = claimsUrl +  "/" + __arg.scenarioArgs.claimId + '/injury-incidents'
    * def createInjuryIncidentTemplate = 'classpath:com/gw/apicomponents/incidents/createInjuryIncident.json'
    Given url injuryIncidentUrl
    And request readWithArgs(createInjuryIncidentTemplate, __arg.templateArgs)
    When method POST
    Then status 201
    * match response.data.attributes.description == "Head trauma, possible concussion"
    * setStepVariable('injuryIncidentId', response.data.attributes.id)