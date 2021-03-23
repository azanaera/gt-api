Feature: Test Data
  To setup test data used by end-to-end scenarios

  Background:
    # Since config is not fully initialized, we should explicitly set config variable to scenario variable.
    * def ccBaseUrl = ccBaseUrl
    * def ccUtilities = claimUtils
    * def ClaimsUserDO = Java.type('com.gw.apicomponents.users.ClaimsUserDO')
    * def adminData = claimsDataContainer
    * def adminUserDataFile = 'classpath:com/gw/datacreation/admindata/ccAdminUsersData.json'
    * def createAdminUsersFromJsonDataFile =
    """
        function() {
          var userData = read(adminUserDataFile);
          for (var key in userData.data.attributes.users) {
            var userdata = userData.data.attributes.users[key];
            var userName = claimUtils.getTestDataUserName(userdata.user);
            var templateArgs = {'userName': userName, 'authorityProfile': userdata.authorityProfile, 'role': userdata.role};
            step('ClaimUsers.CreateUser', {'ccBaseUrl': ccBaseUrl, 'templateArgs': templateArgs});
            var cacheUser = new ClaimsUserDO(getStepVariable('ClaimUsers.CreateUser','userName'), getStepVariable('ClaimUsers.CreateUser','groupId'),getStepVariable('ClaimUsers.CreateUser','userId'));
            adminData.setClaimsUser(userdata.testDataIdentifier, cacheUser);
          }
        }
    """

  @id=SetupUsers
  Scenario: Setup Required Users
    * call createAdminUsersFromJsonDataFile()

