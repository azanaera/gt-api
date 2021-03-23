Feature: A feature file to crate TDM Admin data using TestAPIs.
  Admin data is only created once and is available for rest of the test execution(s).
  Same feature file can be used in GT-API and also can be used from external systems such as GT-UI.

  Background:
    * def ccAdminDataContainerFile = 'classpath:com/gw/datacreation/admindata/claimsDataContainer.json'
    * def adminData = claimsDataContainer
    * def dataWriter = Java.type('com.gw.datacreation.admindata.ClaimsAdminDataResponseWriter');
    * def claimsUserDO = Java.type('com.gw.apicomponents.users.ClaimsUserDO')
    * def readAdminUsersFromJsonDataFile =
    """
        function() {
          try {
            var userData = read(ccAdminDataContainerFile);
            for (var key in userData.adminData.users) {
              var users = userData.adminData.users[key];
              var cacheUser = new claimsUserDO(users.userName, users.groupId, users.userId);
              adminData.setClaimsUser(users.testDataIdentifier, cacheUser);
            }
          }
          catch(e){
             karate.log(e);
             throw e;
          }
        }
    """

    * def createAdminData =
    """
        function() {
          try {
            var jsonDataContainer = read(ccAdminDataContainerFile);
            } catch(e){
             karate.log(e);
             throw e;
          }

          if(jsonDataContainer.isEmpty()) {
            //Admin data is not created . Create admin data
              step('CreateClaimsUsers.SetupUsers');
              dataWriter.saveAdminData();

          } else if(!adminData.isDataLoaded()){
              //Load Admin Data
              //Read it from a output JSON file and put it in Java HashMap object.
              readAdminUsersFromJsonDataFile();
          }
        }
    """

  @id=CCAdminData
  Scenario: Loading claims admin data using Test APIs
    * call createAdminData()