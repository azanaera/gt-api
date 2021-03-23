Feature: Activities
  As an user I want to perform actions on claim activities


  Background:
    * def username = testDataContainer.getUser("ccadjuster1").getName()
    * def password = 'gw'
    * configure headers = read('classpath:headers.js')
    * def claimsUrl = ccBaseUrl + '/rest/claim/v1/claims'
    * def commonUrl = ccBaseUrl + '/rest/common/v1'
    * def closeActivity =
    """
         function(activityLists){
           for (var key in activityLists) {
            var activityId = activityLists[key];
            step('Activities.GetActivityFromList-ccmbr', {'scenarioArgs':{'activityId': activityId}});
            var currentStatus = getStepVariable('Activities.GetActivityFromList-ccmbr','currentStatusCode');
            if ( currentStatus == "complete") {}
            else
              step('Activities.CloseActivity-ccmbr', {'scenarioArgs':{'activityId': activityId}, 'templateArgs': {'activityURI': '/common/v1/activities/' + activityId + '/notes'}});
           }
         }
     """

  @id=CloseAllActivities-ccmbr
  Scenario: I close the claim activities
    * def listOfActivitiesUrl = claimsUrl + '/' + __arg.cucumberDataCache.claimId + '/activities'
    Given url listOfActivitiesUrl
    When method GET
    Then status 200
    * setStepVariable('count', response.count)
    * def listOfIds = karate.jsonPath(response, '$.data[*].attributes.id')
    * def result = closeActivity(listOfIds)

  @id=GetActivityFromList-ccmbr
  Scenario: Get an Activity from the list of claim activities
    * def requiredArguments = ['activityId']
    * def activityUrl = commonUrl + "/activities/" + __arg.scenarioArgs.activityId
    Given url activityUrl
    When method GET
    Then status 200
    And setStepVariable('currentStatusCode', response.data.attributes.status.code)

  @id=CloseActivity-ccmbr
  Scenario: close given activity
    * def requiredArguments = ['activityId']
    * def closeActivityTemplate = 'classpath:com/gw/cucumber/activities/closeActivity.json'
    * def activityToCloseUrl = commonUrl + '/activities/' + __arg.scenarioArgs.activityId + '/complete'
    Given url activityToCloseUrl
    And request readWithArgs(closeActivityTemplate, __arg.templateArgs)
    When method POST
    Then status 200
    * match response.data.attributes.status.code == "complete"




