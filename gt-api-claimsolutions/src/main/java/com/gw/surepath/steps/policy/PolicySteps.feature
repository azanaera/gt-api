Feature: Policy
  Step scenarios that operate on Policies

  @id=PAPolicy
  Scenario: a Personal Auto policy; a Personal Auto policy with comprehensive coverage
    * __arg.cucumberDataCache.policyVehicleId = 'pcveh:1'
    * __arg.cucumberDataCache.policyInsuredId= 'pc:contact_1'
    * __arg.cucumberDataCache.lineOfBusiness = 'PersonalAuto'
    When step('PolicyActions.CreatePolicy', {'scenarioArgs': {'lineOfBusiness': __arg.cucumberDataCache.lineOfBusiness}, 'templateArgs': {'policyVehicleId': __arg.cucumberDataCache.policyVehicleId, 'policyInsuredId': __arg.cucumberDataCache.policyInsuredId}})
    * __arg.cucumberDataCache.policyNumber = getStepVariable('PolicyActions.CreatePolicy','policyNumber')

