Feature: Test Actions
  As a user, I want to use test actions

  Background:
    * def sharedPath = 'classpath:com/gw/apicomponents/policy/'
    * def testActionsUrl = pcBaseUrl + '/rest/testsupport/v1/job-test-actions'
    * configure headers = read('classpath:admin-headers.js')

  @id=CompleteActiveWorkflow
  Scenario: Complete Active Workflow
    * def wait =
    """
      function(){
        java.lang.Thread.sleep(1000);
      }
    """
    * call wait()
    * def completeActiveWorkflowUrl = testActionsUrl + "/" + __arg.scenarioArgs.jobId + '/complete-active-workflow'
    Given url completeActiveWorkflowUrl
    And request read(sharedPath + 'emptyRequest.json')
    When method POST
    Then status 200
