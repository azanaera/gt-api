Feature: Test Data
  To setup test data used by end-to-end scenarios

  Background:
    # Since config is not fully initialized, we should explicitly set config variable to scenario variable.
    * def ccBaseUrl = ccBaseUrl
    * def ccUtilities = claimUtils
    * def ClaimsUserDO = Java.type('com.gw.apicomponents.users.ClaimsUserDO')
    * def dataWriter = Java.type('com.gw.datacreation.admindata.ClaimsAdminDataResponseWriter')
    * def adminData = claimsDataContainer
    * def adminUserDataFile = 'classpath:com/gw/datacreation/admindata/claimsAdminData.json'
    * def createAdminUsersFromJsonDataFile =
    """
        function() {
          try {
            var userData = read(adminUserDataFile);
            for (var key in userData.data.attributes.users) {
              var userdata = userData.data.attributes.users[key];
              var claimsUserName = claimUtils.addRandomInt(userdata.user);  // like adjuster34567
              var templateArgs = {'userName': claimsUserName, 'authorityProfile': userdata.authorityProfile, 'role': userdata.role};
              step('ClaimUsers.CreateUser', {'ccBaseUrl': ccBaseUrl, 'templateArgs': templateArgs});
              var userName = getStepVariable('ClaimUsers.CreateUser','userName');
              var groupId = getStepVariable('ClaimUsers.CreateUser','groupId');
              var userId = getStepVariable('ClaimUsers.CreateUser','userId');
              var cacheUser = new ClaimsUserDO(userName, groupId,userId);
              adminData.setClaimsUser(userdata.testDataIdentifier, cacheUser);
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
    * call createAdminUsersFromJsonDataFile()

