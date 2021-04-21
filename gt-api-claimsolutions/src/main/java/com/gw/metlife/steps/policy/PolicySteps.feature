Feature: Policy
  Step scenarios that operate on Policies

  @id=PAPolicy
  Scenario: a Personal Auto policy; a Personal Auto policy with comprehensive coverage
    * __arg.cucumberDataCache.policyVehicleId = 'pcveh:1'
    * __arg.cucumberDataCache.policyInsuredId= 'pc:contact_1'
    * __arg.cucumberDataCache.lineOfBusiness = 'PersonalAuto'
    When step('PolicyActions.CreatePolicy', {'scenarioArgs': {'lineOfBusiness': __arg.cucumberDataCache.lineOfBusiness}, 'templateArgs': {'policyVehicleId': __arg.cucumberDataCache.policyVehicleId, 'policyInsuredId': __arg.cucumberDataCache.policyInsuredId}})
    * __arg.cucumberDataCache.policyNumber = getStepVariable('PolicyActions.CreatePolicy','policyNumber')

  @id=HOPolicy
  Scenario: a Homeowners policy
    * def parameters = ['policyInformation']
    * __arg.cucumberDataCache.policyInformation = __arg.parameters.policyInformation
    * __arg.cucumberDataCache.lineOfBusiness = 'Homeowners'
    When step('PolicyActions.CreatePolicy', {'scenarioArgs': {'lineOfBusiness': __arg.cucumberDataCache.lineOfBusiness}, 'templateArgs': __arg.cucumberDataCache})
    * __arg.cucumberDataCache.policyNumber = getStepVariable('PolicyActions.CreatePolicy','policyNumber')


  @id=UnverifiedPAPolicy
  Scenario: an unverified Personal Auto policy
    * def parameters = ['effectiveDate', 'expirationDate', 'insuredFirstName', 'insuredLastName']
    * __arg.cucumberDataCache.lineOfBusiness = 'PersonalAuto'
    * def convertToDateFormat =
    """
      function(day) {
        if(day === 'Yesterday') {
          return claimUtils.getDateWithDayOffset(-1,true)
        }
        if(day === 'Tomorrow') {
          return claimUtils.getDateWithDayOffset(1,true)
        }
      }
    """
    * def effectiveDate = convertToDateFormat(__arg.parameters.effectiveDate)
    * def expirationDate = convertToDateFormat(__arg.parameters.expirationDate)
    * step('PolicyActions.CreateUnverifiedPolicy', {'templateArgs': {'lineOfBusiness': __arg.cucumberDataCache.lineOfBusiness, 'effectiveDate': effectiveDate, 'expirationDate': expirationDate, 'insuredFirstName': __arg.parameters.insuredFirstName, 'insuredLastName': __arg.parameters.insuredLastName}})
    * __arg.cucumberDataCache.policyNumber = getStepVariable('PolicyActions.CreateUnverifiedPolicy','policyNumber')

  @id=PAPolicyInformation
  Scenario: I know the {string} for a Personal Auto policy
    * def parameters = ['policyInformation']
    * __arg.cucumberDataCache.policyInformation = __arg.parameters.policyInformation
    * __arg.cucumberDataCache.policyVehicleId = 'pcveh:1'
    * __arg.cucumberDataCache.policyInsuredId= 'pc:contact_1'
    * __arg.cucumberDataCache.lineOfBusiness = 'PersonalAuto'
    When step('PolicyActions.CreatePolicy', {'scenarioArgs': {'lineOfBusiness': __arg.cucumberDataCache.lineOfBusiness}, 'templateArgs': {'policyVehicleId': __arg.cucumberDataCache.policyVehicleId, 'policyInsuredId': __arg.cucumberDataCache.policyInsuredId}})
    * __arg.cucumberDataCache.policyNumber = getStepVariable('PolicyActions.CreatePolicy','policyNumber')
    * eval if (__arg.parameters.policyInformation == "Policy Type") __arg.cucumberDataCache.policyType = __arg.cucumberDataCache.lineOfBusiness
    * eval if (__arg.parameters.policyInformation == "State") __arg.cucumberDataCache.stateCode = 'CA'
    * eval if (__arg.parameters.policyInformation == "ZIP Code") __arg.cucumberDataCache.zipCode = '91145'

  @id=HOPolicyInformation
  Scenario: I know the {string} for a Homeowners policy
    * def parameters = ['policyInformation']
    * __arg.cucumberDataCache.policyInformation = __arg.parameters.policyInformation
    * __arg.cucumberDataCache.lineOfBusiness = 'Homeowners'
    When step('PolicyActions.CreatePolicy', {'scenarioArgs': {'lineOfBusiness': __arg.cucumberDataCache.lineOfBusiness}, 'templateArgs': __arg.cucumberDataCache})
    * __arg.cucumberDataCache.policyNumber = getStepVariable('PolicyActions.CreatePolicy','policyNumber')

  @id=SearchPolicy
  Scenario: I search for the policy
    * step('PolicyActions.SearchPolicy', {'scenarioArgs': {'policyInformation': __arg.cucumberDataCache.policyInformation}, 'templateArgs': __arg.cucumberDataCache})
    * __arg.cucumberDataCache.listOfPolicyNumbers = getStepVariable('PolicyActions.SearchPolicy', 'listOfPolicyNumbers')

  @id=MatchPolicy
  Scenario: I could find the policy
    * step('PolicyActions.MatchPolicyByPolicyNumber', {'scenarioArgs': {'listOfPolicyNumbers': __arg.cucumberDataCache.listOfPolicyNumbers, 'policyNumber': __arg.cucumberDataCache.policyNumber}})


