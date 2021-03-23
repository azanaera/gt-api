Feature: Note
  Step scenarios that operate on Notes

  Background:
    * def username = claimsDataContainer.getClaimsUser(__arg.cucumberDataCache.currentUserRole).getName()

  @id=AddAndGetClaimNote
  Scenario: I can add a note with the following
    * def parameters = ['topic', 'body']
    * def unrestrictedUsername = claimUtils.getUnrestrictedUser()
    When step('NoteActions.AddNoteToClaim', {'scenarioArgs': {'username': unrestrictedUsername, 'claimId': __arg.cucumberDataCache.claimId}, 'templateArgs': __arg.parameters})
    * def noteId = getStepVariable('NoteActions.AddNoteToClaim', 'noteId')
    Then step('NoteActions.GetClaimNotes', {'scenarioArgs': {'username': unrestrictedUsername, 'claimId': __arg.cucumberDataCache.claimId, 'noteId': noteId}})

  @id=AddAndGetServiceRequestNote
  Scenario: I can add a note related to the service request with the following
    * def parameters = ['topic', 'body']
    * def unrestrictedUsername = claimUtils.getUnrestrictedUser()
    When step('NoteActions.CreateNoteForServiceRequest', {'scenarioArgs': {'username': unrestrictedUsername, 'claimId': __arg.cucumberDataCache.claimId}, 'templateArgs': {'topic': __arg.parameters.topic, 'body': __arg.parameters.body, 'serviceId': serviceId}})
    Then step('NoteActions.GetNotesOnServiceRequest', {'scenarioArgs': {'username': unrestrictedUsername, 'claimId': __arg.cucumberDataCache.claimId, 'serviceId': __arg.cucumberDataCache.serviceId}})

  @id=AddAndGetActivityNote
  Scenario: I can add a note related to the activity with the following
    * def parameters = ['topic', 'body']
    * def unrestrictedUsername = claimUtils.getUnrestrictedUser()
    When step('NoteActions.CreateNoteToActivity', {'scenarioArgs': {'username': unrestrictedUsername, 'activityId': __arg.cucumberDataCache.activityId}, 'templateArgs': __arg.parameters})
    * def noteId = getStepVariable('NoteActions.CreateNoteToActivity', 'noteId')
    Then step('NoteActions.GetNotesOnActivity', {'scenarioArgs': {'username': unrestrictedUsername, 'activityId': __arg.cucumberDataCache.activityId, 'noteId': noteId}})