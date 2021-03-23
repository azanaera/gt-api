function (userIdentifier) {
  // Read Admin Input Data File - policyAdminData.json
  var userInputData = read('classpath:com/gw/datacreation/admindata/policyAdminData.json');
  var userGroup;
  var groupProducerCode;

  // Get Group Identifier that the user belongs
  for (var key in userInputData.data.attributes.users) {
    if(userInputData.data.attributes.users[key].userName == userIdentifier) {
      userGroup = userInputData.data.attributes.users[key].groups[0];
      break;
    }
  }

  // Get the Group's Producer Code Identifier
  for (var key in userInputData.data.attributes.groups) {
    if(userInputData.data.attributes.groups[key].groupIdentifier == userGroup) {
      groupProducerCode = userInputData.data.attributes.groups[key].producerCodeIdentifier;
    }
  }
  var producerCodeId = policyDataContainer.getPolicyProducerCode(groupProducerCode).getId();
  setStepVariable('producerCodeId', producerCodeId);
  return producerCodeId;
}