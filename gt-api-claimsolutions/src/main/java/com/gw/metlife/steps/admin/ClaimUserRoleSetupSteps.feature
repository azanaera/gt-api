Feature: Feature file to setup users with a given role

  @id=UserRoleSetup
  Scenario: I am a user with the {string} role
    * def parameters = ['userRole']
    * step('CreateClaimAdminData.CCAdminData', {'scenarioArgs': {}, 'templateArgs': {}})
    * __arg.cucumberDataCache.currentUserRole = __arg.parameters.userRole

