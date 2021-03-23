Feature: Activities
  To create and manage an activity

  Background:
    * def underwriter = policyDataContainer.getPolicyUser("pcunderwriter")
    * def username = underwriter.getName()
    * configure headers = read('classpath:headers.js')
    * def activityUrl = pcBaseUrl + '/rest/common/v1/activities'
    * def sharedPath = 'classpath:com/gw/apicomponents/policy/'

  @id=ValidateBindOnlySubmissionActivity
  Scenario: Validate activity details for a bind only submission
    * def requiredScenarioArguments = ['activityId']
    * def activityDetailUrl = activityUrl +  "/" + __arg.scenarioArgs.activityId
    Given url activityDetailUrl
    When method GET
    Then status 200
    And match response.data.attributes.activityPattern == 'issue_policy'
    And match response.data.attributes.activityType.code == 'general'
    And match response.data.attributes.assignedByUser.displayName == username
    And match response.data.attributes.assignedGroup.displayName == 'Los Angeles Branch UW'
    And match response.data.attributes.assignedUser.displayName == '#notnull'
    And match response.data.attributes.assignmentStatus.code == 'assigned'
    And match response.data.attributes.description == 'Submission has been bound but not yet issued.'
    And match response.data.attributes.escalated == false
    And match response.data.attributes.mandatory == true
    And match response.data.attributes.priority.code == 'high'
    And match response.data.attributes.recurring == false
    And match response.data.attributes.status.code == 'open'
    And match response.data.attributes.subject == 'Issue Policy'

  @id=CompleteActivity
  Scenario:  Complete an activity
    * def requiredScenarioArguments = ['activityId']
    * def emptyRequestTemplate = sharedPath + 'emptyTotalRequest.json'
    * def completeActivityUrl = activityUrl +  "/" + __arg.scenarioArgs.activityId + '/complete'
    Given url completeActivityUrl
    And request read(emptyRequestTemplate)
    When method POST
    Then status 200

  @id=ValidateActivityStatus
  Scenario: Validate Activity Status
    * def requiredScenarioArguments = ['activityId', 'activityStatus']
    * def activityDetailUrl = activityUrl +  "/" + __arg.scenarioArgs.activityId
    * def emptyRequestTemplate = sharedPath + 'emptyRequest.json'
    Given url activityDetailUrl
    When method GET
    Then status 200
    And match response.data.attributes.status.code == __arg.scenarioArgs.activityStatus
