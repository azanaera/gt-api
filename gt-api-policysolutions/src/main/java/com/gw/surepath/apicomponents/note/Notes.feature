Feature: Notes

  Background:
    * def username = policyDataContainer.getPolicyUser(__arg.cucumberDataCache.currentUserRole).getName()
    * def password = 'gw'
    * configure headers = read('classpath:headers.js')
    * def accountsUrl = pcBaseUrl + '/rest/account/v1/accounts'

  @id=AddNoteToAccount
  Scenario: I create an account note with the following
    * def parameters = ['Topic', 'Subject', 'SecurityLevel', 'Body']
    Given url accountsUrl + '/' + __arg.cucumberDataCache.accountId + '/notes'
    And request readWithArgs('classpath:com/gw/surepath/apicomponents/note/addNoteToAccount.json', __arg.parameters)
    When method POST
    Then status 201
    * setStepVariable('noteId', response.data.attributes.id)

  @id=GetAccountNotes
  Scenario: the account should have the following note
    * def parameters = ['Topic', 'Subject', 'SecurityLevel', 'Body']
    Given url accountsUrl + '/' + __arg.cucumberDataCache.accountId + '/notes'
    And param filter = 'subject:eq:'+ __arg.parameters.Subject, 'body:sw:'+ __arg.parameters.Body
    When method GET
    Then status 200
    And match response.data[*].attributes.id contains __arg.cucumberDataCache.noteId