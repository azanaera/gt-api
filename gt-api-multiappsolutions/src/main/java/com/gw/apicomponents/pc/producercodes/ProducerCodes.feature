Feature: Producer Codes
  As a system superuser (su) I want to create additional producer codes for policy operations

  Background:
    * def sharedPath = 'classpath:com/gw/apicomponents/pc/producercodes/'
    * configure headers = read('classpath:pcadmin-headers.js')

  @id=CreateProducerCode
  Scenario: Create producer code
    * def createProducerTemplate = sharedPath + 'createProducerCode.json'
    * def producerCodeUrl = pcBaseUrl + '/rest/testsupport/v1/producer-codes'
    Given url producerCodeUrl
    And request readWithArgs(createProducerTemplate, __arg.templateArgs)
    When method POST
    Then status 201
    * setStepVariable('code', response.data.attributes.code)
    * setStepVariable('id', response.data.attributes.id)
    * setStepVariable('organization', response.data.attributes.organization)