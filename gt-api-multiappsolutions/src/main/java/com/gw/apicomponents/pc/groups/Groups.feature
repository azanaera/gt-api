Feature: Groups
  As a system superuser (su) I want to create additional groups for policy operations

  Background:
    * def sharedPath = 'classpath:com/gw/apicomponents/pc/groups/'
    * configure headers = read('classpath:pcadmin-headers.js')

  @id=CreateGroup
  Scenario: Create group
    * def createGroupTemplate = sharedPath + 'createGroup.json'
    * def groupUrl = pcBaseUrl + '/rest/testsupport/v1/groups'
    Given url groupUrl
    And request readWithArgs(createGroupTemplate, __arg.templateArgs)
    When method POST
    Then status 201
    * setStepVariable('name', response.data.attributes.name)
    * setStepVariable('id', response.data.attributes.id)