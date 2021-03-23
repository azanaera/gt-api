Feature: Users
  As a system superuser (su) I want to create additional users for policy operations

  Background:
    * def sharedPath = 'classpath:com/gw/apicomponents/users/'
    * configure headers = read('classpath:pcadmin-headers.js')

  @id=CreateUser
  Scenario: Create user
	* def createUserTemplate = sharedPath + 'createPolicyUser.json'
    * def userUrl = pcBaseUrl + '/rest/testsupport/v1/users'
    Given url userUrl
    And request readWithArgs(createUserTemplate, __arg.templateArgs)
    When method POST
    Then status 201
    * setStepVariable('userName', response.data.attributes.username)
    * setStepVariable('groupId', response.data.attributes.groupId)
    * setStepVariable('userId', response.data.attributes.id)
