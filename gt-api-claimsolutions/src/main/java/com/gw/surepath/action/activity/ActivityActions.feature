Feature: Activity
  Action scenarios that operate on Activities

  Background:
    * def username = __arg.scenarioArgs.username
    * def password = claimsDataContainer.getPassword()
    * def claimsUrl = ccBaseUrl + '/rest/claim/v1/claims'
    * def activitiesUrl = ccBaseUrl + '/rest/common/v1/activities'
    * configure headers = read('classpath:headers.js')

  @id=CreateActivityOnClaim
  Scenario: Create activity on a claim
    * def requiredArguments = ['claimId']
    Given url claimsUrl + '/' + __arg.scenarioArgs.claimId + '/activities'
    And request readWithArgs('classpath:com/gw/surepath/action/activity/createActivity.json', __arg.templateArgs)
    When method POST
    Then status 201
    * match response.data.attributes.activityPattern == __arg.templateArgs.activityPattern
    * setStepVariable('activityId', response.data.attributes.id)

  @id=GetActivityBySubject
  Scenario: Get Activity By Subject
    * def requiredArguments = ['claimId', 'subject']
    * def activitiesUrl = claimsUrl + '/' + __arg.scenarioArgs.claimId + '/activities'
    Given url activitiesUrl
    When method GET
    Then status 200
    And match response.data[*].attributes.subject contains __arg.scenarioArgs.subject