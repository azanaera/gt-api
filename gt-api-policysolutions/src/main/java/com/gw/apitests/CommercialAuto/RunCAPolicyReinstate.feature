# Note: These test scenarios are included for illustrative purposes only
# and are dependent on appropriate line of business setup.
@RunAll
Feature: As an underwriter I want to test the Commercial Auto Policy Life Cycle

  Background:
    Given step('CreatePolicyAdminData.PCAdminData')
    * def underwriter = policyDataContainer.getPolicyUser("pcunderwriter")
    * def username = underwriter.getName()
    * def password = 'gw'
    * def commonUrl = pcBaseUrl + '/rest/common/v1'
    * def jobEffectiveDate = policyUtil.currentISODateString()
    * configure headers = read('classpath:headers.js')

  @id=CAReinstate
  Scenario: Execute Commercial Auto Policy Reinstate
    Given step('RunCAPolicyLifecycle.CALifecycle')
    * def policyId = getStepVariable('JobCommon.BindAndIssueJob','policyId')
    And step('PolicyCancel.CancelPolicy', {'scenarioArgs': {'policyId': policyId}, 'templateArgs': {'reason': 'flatrewrite', 'source': 'carrier', 'jobEffectiveDate': jobEffectiveDate}})
    * def cancelJobId = getStepVariable('PolicyCancel.CancelPolicy','cancelJobId')
    And step('JobCommon.BindAndIssueJob', {'scenarioArgs': {'jobId':cancelJobId}})
    And step('PolicyReinstate.ReinstatePolicy', {'scenarioArgs': {'policyId':policyId}})
    * def reinstateJobId = getStepVariable('PolicyReinstate.reinstatePolicy','reinstateJobId')
    And step('PolicyReinstate.QuoteReinstatedPolicy', {'scenarioArgs': {'reinstateJobId':reinstateJobId}})
    And step('PolicyReinstate.ReinstateJob', {'scenarioArgs': {'reinstateJobId':reinstateJobId}})
    Then step('PolicyReinstate.ValidateReinstateJob', {'scenarioArgs': {'reinstateJobId':reinstateJobId}})
