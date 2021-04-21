Feature: Activity
  Step scenarios that operate on Claim Activities

  Background:
    * def username = claimsDataContainer.getClaimsUser(__arg.cucumberDataCache.currentUserRole).getName()
    * def getActivityPatternCode =
    """
      function(activity) {
        switch(activity) {
          case 'Get vehicle inspected':
            return 'vehicle_inspection';
          case 'Send claim acknowledgement letter':
            return 'claim_ack_letter';
          default:
            throw 'Unhandled activity pattern: ' + activity;
        }
      }
    """

  @id=CreateActivity
  Scenario: with a planned activity with the following; I create an activity to {string} for the claim
    * def parameters = ['activity']
    * def unrestrictedUsername = claimUtils.getUnrestrictedUser()
    * def activityPattern = getActivityPatternCode(__arg.parameters.activity)
    When step('ActivityActions.CreateActivity', {'scenarioArgs': {'username': unrestrictedUsername, 'claimId': claimId}, 'templateArgs': {'activityPattern': activityPattern}})
    * __arg.cucumberDataCache.activityId = getStepVariable('ActivityActions.CreateActivity','activityId')
    * __arg.cucumberDataCache.activityOwnerId = getStepVariable('ActivityActions.CreateActivity','activityOwnerId')

  @id=ActivityPlanned
  Scenario: an activity is planned; activities are planned
    * def parameters = ['activity']
    * def unrestrictedUsername = claimUtils.getUnrestrictedUser()
    When step('ActivityActions.GetActivityBySubject', {'scenarioArgs': {'username': unrestrictedUsername, 'claimId': __arg.cucumberDataCache.claimId, 'subject': __arg.parameters.activity}})

  @id=ActivityInWorkplan
  Scenario: the activity is in the workplan
    * def unrestrictedUsername = claimUtils.getUnrestrictedUser()
    When step('ActivityActions.EnsureActivityExistsInClaim', {'scenarioArgs': {'username': unrestrictedUsername, 'claimId': __arg.cucumberDataCache.claimId, 'activityId': __arg.cucumberDataCache.activityId}})

  @id=ActivityBelongsToClaimOwner
  Scenario: the activity is assigned to the claim owner
    When step('ActivityActions.MatchActivityOwnerWithClaimOwner', {'scenarioArgs': {'activityOwnerId': __arg.cucumberDataCache.activityOwnerId, 'claimOwnerId': __arg.cucumberDataCache.claimOwnerId}})