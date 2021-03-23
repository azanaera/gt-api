Feature: Admin Data
  To setup test admin data used by end-to-end scenarios

  Background:
    # Since config is not fully initialized, we should explicitly set config variable to scenario variable.
    * def pcBaseUrl = pcBaseUrl
    * def policyUtil = policyUtil
    * def ProducerCodeDO = Java.type('com.gw.apicomponents.pc.producercodes.ProducerCodeDO')
    * def GroupDO = Java.type('com.gw.apicomponents.pc.groups.GroupDO')
    * def UserDO = Java.type('com.gw.apicomponents.users.PolicyUserDO')
    * def adminData = policyDataContainer
    * def adminUserDataFile = 'classpath:com/gw/datacreation/admindata/policyAdminData.json'
    # Take a user list instead?
    * def createAdminUsersFromJsonDataFile =
    """
        function() {
          var userData = read(adminUserDataFile);
          for (var key in userData.data.attributes.users) {
            var user = userData.data.attributes.users[key];
            var groupId = adminData.getPolicyGroup(user.groups[0]).getId();
            var userName = policyUtil.getRandomName('user');
            var templateArgs = {'userName': userName, 'roles': user.roles[0], 'groups': groupId, 'useProducerCodeSecurity': user.useProducerCodeSecurity};
            step('PolicyUsers.CreateUser', {'pcBaseUrl': pcBaseUrl, 'templateArgs': templateArgs});
            var cacheUser = new UserDO(userName, groupId, getStepVariable('PolicyUsers.CreateUser', 'userId'));
            adminData.setPolicyUser(user.userName, cacheUser);
          }
        }
    """

    * def createAdminGroupsFromJsonDataFile =
    """
        function() {
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
          }
        }
    """

    * def createAdminProducerCodesFromJsonDataFile =
    """
        function() {
          var producerCodeData = read(adminUserDataFile);
          for (var key in producerCodeData.data.attributes.producerCodes) {
            var producerCodes = producerCodeData.data.attributes.producerCodes[key];
            var producerCode = policyUtil.getRandomName('producerCode');
            var templateArgs = {'code': producerCode, 'organization': producerCodes.organization, 'roles':'producer'};
            step('ProducerCodes.CreateProducerCode',{'pcBaseUrl': pcBaseUrl,'templateArgs': templateArgs});
            var cacheProducerCode = new ProducerCodeDO(getStepVariable('ProducerCodes.CreateProducerCode','code'),getStepVariable('ProducerCodes.CreateProducerCode', 'id'), getStepVariable('ProducerCodes.CreateProducerCode', 'organization'));
            adminData.setPolicyProducerCode(producerCodes.producerCodeIdentifier, cacheProducerCode);
          }
        }
    """


  @id=SetupProducerCodes
  Scenario: Setup Required Producer Codes
    * call createAdminProducerCodesFromJsonDataFile()

  @id=SetupGroups
  Scenario: Setup Required Groups
    * call createAdminGroupsFromJsonDataFile

  @id=SetupUsers
  Scenario: Setup Required users
    * call createAdminUsersFromJsonDataFile