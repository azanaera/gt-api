Feature: Users
  As a system superuser (su) I want to create additional users for claim operations

  Background:
    * def sharedPath = 'classpath:com/gw/apicomponents/users/'
    * def username = 'su'
    * def password = 'gw'
    * def userUrl = ccBaseUrl + '/rest/testsupport/v1/users'
    * configure headers = read('classpath:headers.js')

  @id=CreateUser
  Scenario: Create user
	* def createUserTemplate = sharedPath + 'createClaimsUser.json'
    Given url userUrl
    And request readWithArgs(createUserTemplate, __arg.templateArgs)
    When method POST
    Then status 201
    * setStepVariable('userName', response.data.attributes.username)
    * setStepVariable('groupId', response.data.attributes.groupId)
    * setStepVariable('userId', response.data.attributes.id)

