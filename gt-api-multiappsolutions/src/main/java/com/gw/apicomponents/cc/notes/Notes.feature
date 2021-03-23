Feature: Notes
  As an adjuster I want to perform actions on claim notes

  Background:
    * def sharedPath = 'classpath:com/gw/apicomponents/cc/notes/'

  @id=CreateNote
  Scenario: Create a note
    * def requiredArguments = ['claimId']
    * def addNoteTemplate = sharedPath + 'createNote.json'
    * def createNoteUrl = claimsUrl + "/" + __arg.scenarioArgs.claimId + '/notes'
    Given url createNoteUrl
    And request readWithArgs(addNoteTemplate , __arg.templateArgs)
    When method POST
    Then status 201
    * match response.data.attributes.body == __arg.templateArgs.body
    * match response.data.attributes.subject == __arg.templateArgs.subject
    * match response.data.attributes.confidential == __arg.templateArgs.confidential
    * match response.data.attributes.topic.code == __arg.templateArgs.topic
    And setStepVariable('noteId', response.data.attributes.id) 

  @id=UpdateNote
  Scenario: Update a note
    * def requiredArguments = ['noteId']
    * def currentNoteUrl = commonUrl +  '/notes/' + __arg.scenarioArgs.noteId
    * def updateNoteTemplate = sharedPath + 'updateNote.json'
    Given url currentNoteUrl
    And request readWithArgs(updateNoteTemplate , __arg.templateArgs)
    When method PATCH
    Then status 200
    * match response.data.attributes.subject == __arg.templateArgs.subject
    * match response.data.attributes.confidential == __arg.templateArgs.confidential
    * match response.data.attributes.topic.code == __arg.templateArgs.topic


  @id=GetNote
    Scenario: Get the note
     * def requiredArguments = ['noteId']
     * def currentNoteUrl = commonUrl +  '/notes/' + __arg.scenarioArgs.noteId
    Given url currentNoteUrl
    When method GET
    Then status 200
    * match response.data.attributes.subject == __arg.scenarioArgs.subject
    * match response.data.attributes.confidential == __arg.scenarioArgs.confidential
    * match response.data.attributes.topic.code == __arg.scenarioArgs.topic

