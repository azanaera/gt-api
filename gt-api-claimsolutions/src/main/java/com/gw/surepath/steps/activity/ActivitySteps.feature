Feature: Activity

  Background:
    * def username = claimsDataContainer.getClaimsUser(__arg.cucumberDataCache.currentUserRole).getName()
    * def getActivityPattern =
    """
      function(activity) {
        switch(activity) {
          case 'Get vehicle inspected':
            return 'vehicle_inspection';
          default:
            throw 'Unhandled activity pattern: ' + activity;
        }
      }
    """
    * def createActivityRelatedTo =
    """
      function(relatedTo) {
        if (relatedTo == 'Claim') {
          step('ActivityActions.CreateActivityOnClaim', {'scenarioArgs': {'username': unrestrictedUsername, 'claimId': claimId}, 'templateArgs': {'activityPattern': activityPattern}})
          return getStepVariable('ActivityActions.CreateActivityOnClaim','activityId')
        }
        else {
          throw 'Unhandled entity the activity relate to: ' + relatedTo
        }
      }
    """

  @id=CreateActivity
  Scenario: with a planned activity with the following
    * def parameters = ['activity', 'for']
    * def unrestrictedUsername = claimUtils.getUnrestrictedUser()
    * def activityPattern = getActivityPattern(__arg.parameters.activity)
    * def activityId = createActivityRelatedTo(__arg.parameters.for)
    * __arg.cucumberDataCache.activityId = activityId

  @id=ActivityPlanned
  Scenario: an activity is planned
    * def parameters = ['activity']
    * def unrestrictedUsername = claimUtils.getUnrestrictedUser()
    When step('ActivityActions.GetActivityBySubject', {'scenarioArgs': {'username': unrestrictedUsername, 'claimId': __arg.cucumberDataCache.claimId, 'subject': __arg.parameters.activity}})