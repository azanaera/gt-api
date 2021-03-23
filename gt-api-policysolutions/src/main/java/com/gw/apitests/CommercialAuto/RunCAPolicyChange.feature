# Note: These test scenarios are included for illustrative purposes only
# and are dependent on appropriate line of business setup.
@RunAll
Feature: As an underwriter I want to test the Commercial Auto Policy Change Scenario

  Background:
    Given step('CreatePolicyAdminData.PCAdminData')
    * def underwriter = policyDataContainer.getPolicyUser("pcunderwriter")
    * def username = underwriter.getName()
    * def password = 'gw'
    * def jobEffectiveDate = policyUtil.currentISODateString()
    * def jobEffectiveDateMidTerm = policyUtil.addMonthsToISODateString(jobEffectiveDate, 3)
    * def secondJobEffectiveDate = policyUtil.addMonthsToISODateString(jobEffectiveDate, 4)
    * configure headers = read('classpath:headers.js')

  @id=CAPolicyChange
  Scenario: Execute Commercial Auto Policy Change
    Given step('RunCAPolicyLifecycle.CALifecycle')
    * def policyId = getStepVariable('JobCommon.BindAndIssueJob','policyId')
    When step('PolicyCommon.ChangePolicy', {'scenarioArgs': {'policyId': policyId}, 'templateArgs': {'description': 'Changing a policy', 'jobEffectiveDate': jobEffectiveDateMidTerm}})
    * def changeJobId = getStepVariable('PolicyCommon.changePolicy','jobId')
    And step('PolicyCommon.GetPolicyLocationId', {'scenarioArgs': {'submissionId':changeJobId}})
    * def locationId = getStepVariable('PolicyCommon.GetPolicyLocationId','locationid')
    And step('BAJob.CreateBusinessVehicle',{'templateArgs': {'locationId':locationId,'vehicleVIN': '8788'}, 'scenarioArgs': {'submissionId':changeJobId} })
    And step('BAJob.SyncLineItems', {'scenarioArgs': {'submissionId':changeJobId,'syncType':'Coverages'}})
    And step('PolicyCommon.QuotePolicy', {'scenarioArgs': {'submissionId':changeJobId}})
    And step('PolicyCommon.ChangePolicy', {'scenarioArgs': {'policyId': policyId}, 'templateArgs': {'description': 'Changing a policy', 'jobEffectiveDate': secondJobEffectiveDate}})
    * def changeJobId2 = getStepVariable('PolicyCommon.changePolicy','jobId')
    And step('BAJob.CreateBusinessVehicle',{'templateArgs': {'locationId': locationId,'vehicleVIN': '3324'}, 'scenarioArgs': {'submissionId':changeJobId2} })
    And step('BAJob.SyncLineItems', {'scenarioArgs': {'submissionId':changeJobId2,'syncType':'Coverages'}})
    And step('PolicyCommon.WithdrawPolicy', {'scenarioArgs': {'submissionId':changeJobId}})
    Then step('JobCommon.ValidateJobStatus', {'scenarioArgs': {'jobId':changeJobId, 'jobStatus':'Withdrawn', 'jobType':'PolicyChange'}})
    When step('PolicyCommon.QuotePolicy', {'scenarioArgs': {'submissionId':changeJobId2}})
    And step('JobCommon.BindAndIssueJob', {'scenarioArgs': {'jobId':changeJobId2}})
    Then step('JobCommon.ValidateJobStatus', {'scenarioArgs': {'jobId':changeJobId2, 'jobStatus':'Bound', 'jobType':'PolicyChange'}})

