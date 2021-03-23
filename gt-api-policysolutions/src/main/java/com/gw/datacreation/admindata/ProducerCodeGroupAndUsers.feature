Feature: Admin Data
  To setup test admin data used by end-to-end scenarios

  Background:
    # Since config is not fully initialized, we should explicitly set config variable to scenario variable.
    * def pcBaseUrl = pcBaseUrl
    * def policyUtil = policyUtil
    * def adminData = policyDataContainer
    * def ProducerCodeDO = Java.type('com.gw.apicomponents.producercodes.ProducerCodeDO')
    * def GroupDO = Java.type('com.gw.apicomponents.groups.GroupDO')
    * def UserDO = Java.type('com.gw.apicomponents.users.PolicyUserDO')
    * def adminUserDataFile = 'classpath:com/gw/datacreation/admindata/policyAdminData.json'
    * def adminJSONDataOutputFile = 'classpath:com/gw/datacreation/admindata/policyDataContainer.json'
    * def dataWriter = Java.type('com.gw.datacreation.admindata.PolicyAdminDataResponseWriter');
    # Take a user list instead?
    * def createAdminUsersFromJsonDataFile =
    """
        function() {
          try {
            var userData = read(adminUserDataFile);

            for (var key in userData.data.attributes.users) {
              var user = userData.data.attributes.users[key];
              var groupId = adminData.getPolicyGroup(user.groups[0]).getId();
              var userName = policyUtil.getRandomName('user');
              var templateArgs = {'userName': userName, 'roles': user.roles[0], 'groups': groupId, 'useProducerCodeSecurity': user.useProducerCodeSecurity};
              step('PolicyUsers.CreateUser', {'pcBaseUrl': pcBaseUrl, 'templateArgs': templateArgs});
              var cacheUser = new UserDO(userName, groupId, getStepVariable('PolicyUsers.CreateUser', 'userId'));
              adminData.setPolicyUser(user.userName, cacheUser);
              dataWriter.addUser(user.userName, userName, groupId, getStepVariable('PolicyUsers.CreateUser', 'userId'));
            }
          }
          catch(e){
             karate.log(e);
             throw e;
          }
        }
    """

    * def createAdminGroupsFromJsonDataFile =
    """
        function() {
          try {
            var groupData = read(adminUserDataFile);
            for (var key in groupData.data.attributes.groups) {
              var group = groupData.data.attributes.groups[key];
              var groupName = policyUtil.getRandomName('group');
              var producerCode = adminData.getPolicyProducerCode(group.producerCodeIdentifier).getId();
              var organization = adminData.getPolicyProducerCode(group.producerCodeIdentifier).getOrganization();
              var templateArgs = {'userName': groupName, 'organization': organization, 'producerCodes':producerCode};
              step('Groups.CreateGroup', {'pcBaseUrl': pcBaseUrl, 'templateArgs': templateArgs});
              var cacheGroup = new GroupDO(groupName, getStepVariable('Groups.CreateGroup','id'));
              adminData.setPolicyGroup(group.groupIdentifier, cacheGroup);
              dataWriter.addGroup(group.groupIdentifier, groupName, getStepVariable('Groups.CreateGroup','id'));
            }
          }
          catch(e){
             karate.log(e);
             throw e;
          }
        }
    """

    * def createAdminProducerCodesFromJsonDataFile =
    """
        function() {
          try {
            var producerCodeData = read(adminUserDataFile);
            var jsonOutput = "";
            for (var key in producerCodeData.data.attributes.producerCodes) {
              var producerCodes = producerCodeData.data.attributes.producerCodes[key];
              var producerCode = policyUtil.getRandomName('producerCode');
              var templateArgs = {'code': producerCode, 'organization': producerCodes.organization, 'roles':'producer'};
              step('ProducerCodes.CreateProducerCode',{'pcBaseUrl': pcBaseUrl,'templateArgs': templateArgs});
              var producerCode = getStepVariable('ProducerCodes.CreateProducerCode','code');
              var producerId = getStepVariable('ProducerCodes.CreateProducerCode', 'id');
              var orgId = getStepVariable('ProducerCodes.CreateProducerCode', 'organization');
              var cacheProducerCode = new ProducerCodeDO(producerCode ,producerId, orgId);
              adminData.setPolicyProducerCode(producerCodes.producerCodeIdentifier, cacheProducerCode);
              dataWriter.addProducerCode(producerCodes.producerCodeIdentifier, producerCode, producerId, orgId);
            }
          }
          catch(e){
             karate.log(e);
             throw e;
          }
        }
    """


  @id=SetupProducerCodes
  Scenario: Setup Required Producer Codes
    * call createAdminProducerCodesFromJsonDataFile

  @id=SetupGroups
  Scenario: Setup Required Groups
    * call createAdminGroupsFromJsonDataFile

  @id=SetupUsers
  Scenario: Setup Required users
    * call createAdminUsersFromJsonDataFile