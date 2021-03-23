# Note: These test scenarios are included for illustrative purposes only
# and are dependent on appropriate line of business setup.
@RunAll
Feature: As an underwriter I want to test the Commercial Auto Policy Cancellation Scenario

  Background:
    Given step('CreatePolicyAdminData.PCAdminData')
    * def underwriter = policyDataContainer.getPolicyUser("pcunderwriter")
    * def username = underwriter.getName()
    * def password = 'gw'
    * def commonUrl = pcBaseUrl + '/rest/common/v1'
    * def jobEffectiveDate = policyUtil.currentISODateString()
    * def jobEffectiveDateMidTerm = policyUtil.addMonthsToISODateString(jobEffectiveDate, 3)
    * configure headers = read('classpath:headers.js')

  @id=CACancellation
  Scenario: Execute Commercial Auto Cancellation
    Given step('RunCAPolicyLifecycle.CALifecycle')
    * def policyId = getStepVariable('JobCommon.BindAndIssueJob','policyId')
    And step('PolicyCancel.CancelPolicy', {'scenarioArgs': {'policyId': policyId}, 'templateArgs': {'reason': 'nottaken', 'source': 'insured', 'jobEffectiveDate': jobEffectiveDate}})
    * def cancelJobId = getStepVariable('PolicyCancel.CancelPolicy','cancelJobId')
    And step('JobCommon.BindAndIssueJob', {'scenarioArgs': {'jobId':cancelJobId}})
    Then step('JobCommon.ValidateJobStatus', {'scenarioArgs': {'jobId':cancelJobId, 'jobStatus':'Bound', 'jobType':'Cancellation'}})

  @id=CAMidTermCancellation
  Scenario: Execute Commercial Auto Mid Term Cancellation
    Given step('Accounts.AddCompany', {'templateArgs': {'accountContactCompanyName': 'Company ABC'}})
    * def accountId = getStepVariable('Accounts.AddCompany', 'id')
    And step('RunCAPolicyLifecycle.CALifecycle', {'scenarioArgs': {'accountId':accountId}})
    * def policyId = getStepVariable('JobCommon.BindAndIssueJob','policyId')
    And step('PolicyCancel.CancelPolicy', {'scenarioArgs': {'policyId': policyId}, 'templateArgs': {'reason': 'midtermrewrite', 'source': 'carrier', 'jobEffectiveDate': jobEffectiveDateMidTerm}})
    * def cancelJobId = getStepVariable('PolicyCancel.CancelPolicy','cancelJobId')
    And step('JobCommon.BindAndIssueJob', {'scenarioArgs': {'jobId':cancelJobId}})
    Then step('JobCommon.ValidateJobStatus', {'scenarioArgs': {'jobId':cancelJobId, 'jobStatus':'Bound', 'jobType':'Cancellation'}})