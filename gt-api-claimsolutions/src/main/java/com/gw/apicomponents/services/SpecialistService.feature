Feature: Specialist Service
  As a superuser (su) I want to create a new specialist service

  Background:
    * def username = 'su'
    * def password = 'gw'
    * configure headers = read('classpath:headers.js')
    * def specialistServiceUrl = ccBaseUrl + '/rest/testsupport/v1/specialist-services'


  @id=CreateSpecialistService
  Scenario: Create a new specialist service
    * def createSpecialistServiceTemplate = 'classpath:com/gw/apicomponents/services/createSpecialistService.json'
    Given url specialistServiceUrl
    And request readWithArgs(createSpecialistServiceTemplate, __arg.templateArgs)
    When method POST
    Then status 201
    * setStepVariable('specialistServiceId', response.data.attributes.id)