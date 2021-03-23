Feature: Feature file to setup users with a given role

  Background:
    * def setupUserRole =
    """
        function(userRole) {
          // Create Admin data if not already created
          step('CreatePolicyAdminData.PCAdminData');
          __arg.cucumberDataCache.currentUserRole = userRole
        }
    """

  @id=UserRoleSetup
  Scenario: I am a user with the {string} role
    * def parameters = ['userRole']
    * call setupUserRole(__arg.parameters.userRole)

