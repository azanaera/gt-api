Feature: Note
  Action scenarios that operate on Claim Notes

  Background:
    * def username = __arg.scenarioArgs.username
    * def password = claimsDataContainer.getPassword()
    * configure headers = read('classpath:headers.js')
    * def claimsUrl = ccBaseUrl + '/rest/claim/v1/claims'
    * def activitiesUrl = ccBaseUrl + '/rest/common/v1/activities'
    * def sharedPath = 'classpath:com/gw/surepath/action/note/'

  @id=AddNoteToClaim
  Scenario: Add a note to the existing claim
    * def requiredArguments = ['claimId']
    Given url claimsUrl + '/' + __arg.scenarioArgs.claimId + '/notes'
    And request readWithArgs(sharedPath + 'addNoteToClaim.json', __arg.templateArgs)
    When method POST
    Then status 201
    * match response.data.attributes.topic.code == __arg.templateArgs.topic
    * match response.data.attributes.body == __arg.templateArgs.body
    * setStepVariable('noteId', response.data.attributes.id)

  @id=CreateNoteForServiceRequest
  Scenario: Create a note for a service request
    * def requiredArguments = ['claimId']
    Given url claimsUrl + '/' + __arg.scenarioArgs.claimId + '/notes'
    And request readWithArgs(sharedPath + 'addNoteToService.json', __arg.templateArgs)
    When method POST
    Then status 201
    * match response.data.attributes.topic.code == __arg.templateArgs.topic
    * match response.data.attributes.body == __arg.templateArgs.body
    * setStepVariable('noteId', response.data.attributes.id)

  @id=CreateNoteToActivity
  Scenario: Create a note to an activity
    * def requiredArguments = ['activityId']
    Given url activitiesUrl + '/' + __arg.scenarioArgs.activityId + '/notes'
    And request readWithArgs(sharedPath + 'addNoteToActivity.json', __arg.templateArgs)
    When method POST
    Then status 201
    * match response.data.attributes.topic.code == __arg.templateArgs.topic
    * match response.data.attributes.body == __arg.templateArgs.body
    * setStepVariable('noteId', response.data.attributes.id)

  @id=GetClaimNotes
  Scenario: Check if the note exists on the claim
    * def requiredArguments = ['claimId', 'noteId']
    Given url claimsUrl + '/' + __arg.scenarioArgs.claimId + '/notes'
    When method GET
    Then status 200
    And match response.data[*].attributes.id contains __arg.scenarioArgs.noteId

  @id=GetNotesOnServiceRequest
  Scenario: Check if the note exists on the service
    * def requiredArguments = ['claimId', 'serviceRequestId']
    Given url claimsUrl + '/' + __arg.scenarioArgs.claimId + '/notes'
    When method GET
    Then status 200
    And match response.data[*].attributes.relatedTo.id contains __arg.scenarioArgs.serviceRequestId

  @id=GetNotesOnActivity
  Scenario: Check if the note exists on the activity
    * def requiredArguments = ['activityId', 'noteId']
    Given url activitiesUrl + '/' + __arg.scenarioArgs.activityId + '/notes'
    When method GET
    Then status 200
    * match response.data[*].attributes.id contains __arg.scenarioArgs.noteId