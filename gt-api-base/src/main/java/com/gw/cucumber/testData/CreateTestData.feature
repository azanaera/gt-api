Feature: A feature file to create TDM Admin data using TestAPIs.
  Admin data is only created once and is available for rest of the test execution(s).

  Background:
    * def testDataFile = 'classpath:com/gw/cucumber/testData/testDataContainer.json'
    * def testData = testDataContainer
    * def dataWriter = Java.type('com.gw.cucumber.testData.TestDataResponseWriter')
    * def UserDO = Java.type('com.gw.cucumber.users.TestUser')
    * def readTestUsersFromJsonDataFile =
    """
        function() {
          try {
            var userData = read(testDataFile);
            for (var key in userData.testData.users) {
              var users = userData.testData.users[key];
              var cacheUser = new UserDO(users.userName, users.groupId, users.userId);
              testData.setUser(users.testDataIdentifier, cacheUser);
            }
          }
          catch(e){
             karate.log(e);
             throw e;
          }
        }
    """

    * def createTestData =
    """
        function() {
          try {
            var jsonDataContainer = read(testDataFile);
          }
          catch(e){
             karate.log(e);
             throw e;
          }

          if(jsonDataContainer.isEmpty()) {
            //Test Admin data is not created . Create admin data
              step('TestData.SetupUsers');
              dataWriter.saveTestData();

          } else if(!testData.isDataLoaded()){
              //Load Test Admin Data
              //Read it from a output JSON file and put it in Java HashMap object.
              readTestUsersFromJsonDataFile();
          }
        }
    """

  @id=TestDataSetup
  Scenario: I create admin data using Test APIs
    * call createTestData()