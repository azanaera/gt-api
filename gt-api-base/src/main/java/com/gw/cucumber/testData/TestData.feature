Feature: Test Data
  To setup test data used by end-to-end scenarios

  Background:
  * def ccBaseUrl = ccBaseUrl
  * def testUtilities = testUtils
  * def TestUser = Java.type('com.gw.cucumber.users.TestUser')
  * def testData = testDataContainer
  * def dataWriter = Java.type('com.gw.cucumber.testData.TestDataResponseWriter')
  * def testUserDataFile = 'classpath:com/gw/cucumber/testData/testAdminData.json'
  * def createUsersFromJsonDataFile =
  """
      function() {
        try {
          var userData = read(testUserDataFile);
          for (var key in userData.data.attributes.users) {
            var userdata = userData.data.attributes.users[key];
            var testUserName = testUtilities.getTestDataUserName();
            var templateArgs = {'userName': testUserName, 'authorityProfile': userdata.authorityProfile, 'role': userdata.role};
            step('Users.CreateUser', {'ccBaseUrl': ccBaseUrl, 'templateArgs': templateArgs});
            var userName = getStepVariable('Users.CreateUser','userName');
            var groupId = getStepVariable('Users.CreateUser','groupId');
            var userId = getStepVariable('Users.CreateUser','userId');
            var cacheUser = new TestUser(userName, groupId, userId);
            testData.setUser(userdata.testDataIdentifier, cacheUser);
            dataWriter.addUser(userdata.testDataIdentifier, userName, groupId, userId)
          }
        }
        catch(e){
           karate.log(e);
           throw e;
        }
      }
  """

  @id=SetupUsers
  Scenario: Setup Required Users
    * call createUsersFromJsonDataFile()