Feature: A feature file to crate TDM Admin data using TestAPIs.
  Admin data is only created once and is available for rest of the test execution(s).
  Same feature file can be used in GT-API and also can be used from external systems such as GT-UI.

  Background:
    * def adminUserDataFile = 'classpath:com/gw/datacreation/admindata/policyAdminData.json'
    * def pcAdminDataContainerFile = 'classpath:com/gw/datacreation/admindata/policyDataContainer.json'
    * def adminData = policyDataContainer
    * def dataWriter = Java.type('com.gw.datacreation.admindata.PolicyAdminDataResponseWriter');
    * def ProducerCodeDO = Java.type('com.gw.apicomponents.producercodes.ProducerCodeDO')
    * def GroupDO = Java.type('com.gw.apicomponents.groups.GroupDO')
    * def UserDO = Java.type('com.gw.apicomponents.users.PolicyUserDO')
    * def readAdminUsersFromJsonDataFile =
    """
        function() {
          try {
              var userData = read(pcAdminDataContainerFile);

              for (var key in userData.adminData.users) {
                var users = userData.adminData.users[key];
                var cacheUser = new UserDO(users.userName, users.groupId, users.userId);
                adminData.setPolicyUser(users.userIdentifier, cacheUser);
              }
          }
          catch(e){
             karate.log(e);
             throw e;
          }
        }
    """

    * def readAdminGroupsFromJsonDataFile =
    """
        function() {
          try {
            var groupData = read(pcAdminDataContainerFile);

            for (var key in groupData.adminData.groups) {
              var groups = groupData.adminData.groups[key];
              var cacheGroup = new GroupDO(groups.groupName, groups.groupId);
              adminData.setPolicyGroup(groups.groupIdentifier, cacheGroup);
            }
          }
          catch(e){
            karate.log(e);
            throw e;
          }
        }
    """

    * def readAdminProducerCodesFromJsonDataFile =
    """
        function() {
          try {
            var producerCodeData = read(pcAdminDataContainerFile);

            for (var key in producerCodeData.adminData.producerCodes) {
              var producerCodes = producerCodeData.adminData.producerCodes[key];
              var cacheProducerCode = new ProducerCodeDO(producerCodes.producerCode, producerCodes.producerCodeId, producerCodes.organizationId);
              adminData.setPolicyProducerCode(producerCodes.producerCodeIdentifier, cacheProducerCode);
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
            var jsonDataContainer = read(pcAdminDataContainerFile);
          }
            catch(e){
             karate.log(e);
             throw e;
          }

          if(jsonDataContainer.isEmpty()) {
            //Admin data is not created . Create admin data
              step('ProducerCodeGroupAndUsers.SetupProducerCodes');
              step('ProducerCodeGroupAndUsers.SetupGroups');
              step('ProducerCodeGroupAndUsers.SetupUsers');
              dataWriter.saveAdminData();

          } else if(!adminData.isDataLoaded()){
              //Load Admin Data
              //Read it from a output JSON file and put it in Java HashMap object.
              readAdminProducerCodesFromJsonDataFile();
              readAdminGroupsFromJsonDataFile();
              readAdminUsersFromJsonDataFile();
          }
        }
    """

  @id=PCAdminData
  Scenario: Loading policy admin data using Test APIs
    * call createAdminData()