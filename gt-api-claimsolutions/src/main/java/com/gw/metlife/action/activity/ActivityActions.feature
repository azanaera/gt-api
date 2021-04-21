Feature: Activity
  Action scenarios that operate on Activities

  Background:
    * def username = __arg.scenarioArgs.username
    * def password = claimsDataContainer.getPassword()
    * def claimsUrl = ccBaseUrl + '/rest/claim/v1/claims'
    * def activitiesUrl = ccBaseUrl + '/rest/common/v1/activities'
    * def commonUrl = ccBaseUrl + '/rest/common/v1'
    * configure headers = read('classpath:headers.js')

  @id=CreateActivity
  Scenario: Create an activity
    * def requiredArguments = ['claimId']
    Given url claimsUrl + '/' + __arg.scenarioArgs.claimId + '/activities'
    And request readWithArgs('classpath:com/gw/surepath/action/activity/createActivity.json', __arg.templateArgs)
    When method POST
    Then status 201
    * match response.data.attributes.activityPattern == __arg.templateArgs.activityPattern
    * setStepVariable('activityId', response.data.attributes.id)
    * setStepVariable('activityOwnerId', response.data.attributes.assignedUser.id)

  @id=GetActivityBySubject
  Scenario: Get activity by subject
    * def requiredArguments = ['claimId', 'subject']
    * def activitiesUrl = claimsUrl + '/' + __arg.scenarioArgs.claimId + '/activities'
    Given url activitiesUrl
    When method GET
    Then status 200
    And match response.data[*].attributes.subject contains __arg.scenarioArgs.subject

  @id=EnsureActivityExistsInClaim
  Scenario: Ensure the activity exists in the claim
    * def requiredArguments = ['claimId', 'activityId']
    * def activitiesUrl = claimsUrl + '/' + __arg.scenarioArgs.claimId + '/activities'
    Given url activitiesUrl
    When method GET
    Then status 200
    And match response.data[*].attributes.id contains __arg.scenarioArgs.activityId

  @id=MatchActivityOwnerWithClaimOwner
  Scenario: Match activity owner with claim owner
    * def requiredArguments = ['activityOwnerId', 'claimOwnerId']
    * match __arg.scenarioArgs.activityOwnerId == __arg.scenarioArgs.claimOwnerId