Feature: Common
  As a user, I want to modify common object

  Background:
    * def emptyJsonPath = 'classpath:com/gw/apicomponents/common/'
    * def commonUrl = pcBaseUrl + '/rest/common/v1/'
    * configure headers = read('classpath:headers.js')

  @id=DeleteDocument
  Scenario: Delete a document
    * def requiredArguments = ['documentId']
    * def emptyRequestTemplate = emptyJsonPath + 'emptyRequest.json'
    * def documentCommonUrl = commonUrl + 'documents/'  + __arg.scenarioArgs.documentId
    Given url documentCommonUrl
    And request read(emptyRequestTemplate)
    When method DELETE
    Then status 204