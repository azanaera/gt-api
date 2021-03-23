Feature: Activities
  As a user I want to perform actions on claim activities


  Background:
    * def closeActivity =
    """
         function(activityLists){
           for (var key in activityLists) {
            var activityId = activityLists[key];
            step('Activities.GetActivityFromList', {'scenarioArgs':{'activityId': activityId}});
            var currentStatus = getStepVariable('Activities.GetActivityFromList','currentStatusCode');
            if ( currentStatus == "complete") {}
            else
              step('Activities.CloseActivity', {'scenarioArgs':{'activityId': activityId}, 'templateArgs': {'activityURI': '/common/v1/activities/' + activityId + '/notes'}});
           }
         }
     """
    * def skipAllActivities =
   """
   function(activityLists) {
     for (var key in activityLists) {
            var activityId = activityLists[key];
            step('Activities.SkipActivity', {'scenarioArgs':{'activityId': activityId}});
     }
   }
   """

  @id=GetActivityFromList
  Scenario: Get an Activity from the list of claim activities
    * def requiredArguments = ['activityId']
    * def activityUrl = commonUrl + "/activities/" + __arg.scenarioArgs.activityId
    Given url activityUrl
    When method GET
    Then status 200
    And setStepVariable('currentStatusCode', response.data.attributes.status.code)


  @id=CreateActivity #The id tag needs to be defined on new line than that of other tags.
  Scenario: Create an activity
    #Framework validation enforced only for requiredArguments
    * def requiredArguments = ['claimId']
    * def createActivityTemplate = 'classpath:com/gw/apicomponents/activities/createActivity.json'
    * def createActivityUrl = claimsUrl + '/' + __arg.scenarioArgs.claimId + '/activities'
    Given url createActivityUrl
    And request readWithArgs(createActivityTemplate, __arg.templateArgs)
    When method POST
    Then status 201
    * match response.data.attributes.activityPattern == __arg.templateArgs.activityPattern
    * match response.data.attributes.description == __arg.templateArgs.activityDescription
    * match response.data.attributes.subject == __arg.templateArgs.activitySubject
    And setStepVariable('activityId', response.data.attributes.id)
    And setStepVariable('activitySubject', response.data.attributes.subject)

  @id=CloseAllActivities
  Scenario: gets the list of activities and close them by calling CloseActivity scenario
    * def requiredArguments = ['claimId']
    * def listOfActivitiesUrl = claimsUrl + '/' + __arg.scenarioArgs.claimId + '/activities'
    Given url listOfActivitiesUrl
    When method GET
    Then status 200
    * setStepVariable('count', response.count)
    * def listOfIds = karate.jsonPath(response, '$.data[*].attributes.id')
    * def result = closeActivity(listOfIds)

  @id=CloseActivity
  Scenario: close given activity
    * def requiredArguments = ['activityId']
    * def closeActivityTemplate = 'classpath:com/gw/apicomponents/activities/closeActivity.json'
    * def activityToCloseUrl = commonUrl + '/activities/' + __arg.scenarioArgs.activityId + '/complete'
    Given url activityToCloseUrl
    And request readWithArgs(closeActivityTemplate, __arg.templateArgs)
    When method POST
    Then status 200
    * match response.data.attributes.status.code == "complete"

  @id=EditActivityDescription
  Scenario: Edit Activity description
    * def requiredArguments = ['activityId']
    * def editActivityTemplate = 'classpath:com/gw/apicomponents/activities/editActivity.json'
    * def activityPatchUrl = commonUrl + "/activities/" + __arg.scenarioArgs.activityId
    Given url activityPatchUrl
    And request readWithArgs(editActivityTemplate, __arg.templateArgs)
    When method PATCH
    Then status 200
    * match response.data.attributes.description ==  __arg.templateArgs.activityDescriptionNew

  @id=ReassignActivity
  Scenario: Reassign Activity to another Adjuster
    * def requiredArguments = ['activityId']
    * def activityUrl = commonUrl + "/activities/" + __arg.scenarioArgs.activityId + "/assign"
    * def reassignActivityTemplate = 'classpath:com/gw/apicomponents/activities/reassignActivity.json'
    Given url activityUrl
    And request readWithArgs(reassignActivityTemplate, __arg.templateArgs)
    When method POST
    Then status 200
    * match response.data.attributes.assignedUser.displayName ==  __arg.scenarioArgs.newUser

  @id=GetActivity
  Scenario: Get Activity
    * def requiredArguments = ['activityId']
    * def activityUrl = commonUrl + "/activities/" + __arg.scenarioArgs.activityId
    Given url activityUrl
    When method GET
    Then status 200
    * match response.data.attributes.subject ==  __arg.scenarioArgs.activitySubject

  @id=SkipActivities
  Scenario: get the list of activities and call SkipActivity to skip each activity
    * def requiredArguments = ['claimId']
    * def listOfActivitiesToSkipUrl = claimsUrl +  "/" + __arg.scenarioArgs.claimId + '/activities'
    Given url listOfActivitiesToSkipUrl
    When method GET
    Then status 200
    * setStepVariable('count', response.count)
    * def listOfIdsToSkip = karate.jsonPath(response, '$.data[*].attributes.id')
    * def result = skipAllActivities(listOfIdsToSkip)

    #Activity Id should be passed
  @id=SkipActivity
  Scenario: skip individual activity
    * def requiredArguments = ['activityId']
    * def activitytoskipUrl = commonUrl + '/activities/' +  __arg.scenarioArgs.activityId + '/skip'
    Given url activitytoskipUrl
    And request read('classpath:com/gw/apicomponents/EmptyActivityRequest.json')
    When method POST
    Then status 200
    * match response.data.attributes.status.code == "skipped"

  @id=GetAllActivitiesForCurrentUser
  Scenario: gets the list of activities for current user
    * def listOfAllActivitiesUrl = commonUrl + '/activities'
    Given url listOfAllActivitiesUrl
    When method GET
    Then status 200
    * def listOfIds = karate.jsonPath(response, '$.data[*].attributes.id')
    * match listOfIds != '#[0]'
    * setStepVariable('activitiesCount', response.count)
    * setStepVariable('currentUser', response.data[0].attributes.assignedUser.displayName)