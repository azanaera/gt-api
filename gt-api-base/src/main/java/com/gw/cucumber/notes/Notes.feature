Feature: Notes
  As an adjuster I want to perform actions on claim notes

  Background:
    * def username = testDataContainer.getUser("ccadjuster1").getName()
    * def password = 'gw'
    * configure headers = read('classpath:headers.js')
    * def claimsUrl = ccBaseUrl + '/rest/claim/v1/claims'
    * def commonUrl = ccBaseUrl + '/rest/common/v1'

  @id=CreateNote
  Scenario: I add a {string} note with body {string} and subject {string} and topic {string} to the claim
    * def parameters = ['confidentiality','body', 'subject', 'topic']
    * __arg.confidentiality = __arg.parameters.confidentiality == 'public' ? false : true;
    * def addNoteTemplate = 'classpath:com/gw/cucumber/notes/CreateNote.json'
    * def createNoteUrl = claimsUrl + "/" + __arg.cucumberDataCache.claimId + '/notes'
    * def requestPayload = readWithArgs(addNoteTemplate , __arg)
    Given url createNoteUrl
    And request requestPayload
    When method POST
    Then status 201
    * match response.data.attributes.body == requestPayload.data.attributes.body
    * match response.data.attributes.subject == requestPayload.data.attributes.subject
    * match response.data.attributes.confidential == requestPayload.data.attributes.confidential
    * match response.data.attributes.topic.code == requestPayload.data.attributes.topic.code
    And setStepVariable('noteId', response.data.attributes.id)

  @id=CreateNoteWithBody
  Scenario: I add a {string} note with body {string}
    * def parameters = ['confidentiality','body', 'subject', 'topic']
    * __arg.confidentiality = __arg.parameters.confidentiality == 'public' ? false : true;
    * def addNoteTemplate = 'classpath:com/gw/cucumber/notes/CreateNote.json'
    * def createNoteUrl = claimsUrl + "/" + __arg.cucumberDataCache.claimId + '/notes'
    * def requestPayload = readWithArgs(addNoteTemplate , __arg)
    Given url createNoteUrl
    And request requestPayload
    When method POST
    Then status 201
    * match response.data.attributes.body == requestPayload.data.attributes.body
    * match response.data.attributes.subject == requestPayload.data.attributes.subject
    * match response.data.attributes.confidential == requestPayload.data.attributes.confidential
    * match response.data.attributes.topic.code == requestPayload.data.attributes.topic.code
    And setStepVariable('noteId', response.data.attributes.id)

  @id=CreateNotesWithBody
  Scenario: I add {string} notes with body {string}
    * def parameters = ['confidentiality','body', 'subject', 'topic']
    * __arg.confidentiality = __arg.parameters.confidentiality == 'public' ? false : true;
    * def addNoteTemplate = 'classpath:com/gw/cucumber/notes/CreateNote.json'
    * def createNoteUrl = claimsUrl + "/" + __arg.cucumberDataCache.claimId + '/notes'
    * def requestPayload = readWithArgs(addNoteTemplate , __arg)
    Given url createNoteUrl
    And request requestPayload
    When method POST
    Then status 201
    * match response.data.attributes.body == requestPayload.data.attributes.body
    * match response.data.attributes.subject == requestPayload.data.attributes.subject
    * match response.data.attributes.confidential == requestPayload.data.attributes.confidential
    * match response.data.attributes.topic.code == requestPayload.data.attributes.topic.code
    And setStepVariable('noteId', response.data.attributes.id)

  @id=UpdateNote
  Scenario: I update the claim note to be {string} and its subject to be {string} and its topic to be {string}
    * def parameters = ['confidentiality','subject', 'topic']
    * def currentNoteUrl = commonUrl +  '/notes/' + __arg.cucumberDataCache.noteId
    * def updateNoteTemplate = 'classpath:com/gw/cucumber/notes/UpdateNote.json'
    * __arg.confidentiality = __arg.confidentiality == 'public' ? false : true;
    * def requestPayload = readWithArgs(updateNoteTemplate , __arg)
    Given url currentNoteUrl
    And request requestPayload
    When method PATCH
    Then status 200
    * match response.data.attributes.subject == requestPayload.data.attributes.subject
    * match response.data.attributes.confidential == requestPayload.data.attributes.confidential
    * match response.data.attributes.topic.code == requestPayload.data.attributes.topic.code

    @id=GetNote
    Scenario: the claim note is {string} and its subject is {string} and its topic is {string}
      * def parameters = ['confidentiality','subject', 'topic']
      * __arg.parameters.confidentiality = __arg.parameters.confidentiality == 'public' ? false : true;
      * def currentNoteUrl = commonUrl +  '/notes/' + __arg.cucumberDataCache.noteId
      Given url currentNoteUrl
      When method GET
      Then status 200
      * match response.data.attributes.subject == __arg.parameters.subject
      * match response.data.attributes.confidential == __arg.parameters.confidentiality
      * match response.data.attributes.topic.code == __arg.parameters.topic

