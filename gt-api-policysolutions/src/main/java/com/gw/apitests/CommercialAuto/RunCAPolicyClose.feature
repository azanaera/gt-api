# Note: These test scenarios are included for illustrative purposes only
# and are dependent on appropriate line of business setup.
@RunAll
Feature: As an underwriter I want to test the Commercial Auto Policy Close Scenario

   Background:
     Given step('CreatePolicyAdminData.PCAdminData')
     * def underwriter = policyDataContainer.getPolicyUser("pcunderwriter")
     * def username = underwriter.getName()
     * def password = 'gw'
     * def policyUrl = pcBaseUrl + '/rest/job/v1/jobs'
     * def commonUrl = pcBaseUrl + '/rest/common/v1'
     * def jobEffectiveDate = policyUtil.currentISODateString()
     * configure headers = read('classpath:headers.js')

   @id=CAWithdraw
   Scenario: Execute Commercial Auto Quote and Withdraw a submission
    Given step('Accounts.AddCompany', {'templateArgs': {}})
      * def companyId = getStepVariable('Accounts.AddCompany', 'id')
    When step('PolicyCommon.SubmitPolicy', {'templateArgs': {'companyId': companyId, 'jobEffectiveDate': jobEffectiveDate}})
    * def draftSubmissionId = getStepVariable('PolicyCommon.SubmitPolicy','submissionId')
    And step('BAJob.PatchBusinessAutoPolicyType', {'templateArgs': { }, 'scenarioArgs': {'submissionId':draftSubmissionId}})
    And step('PolicyCommon.GetPolicyLocationId', {'scenarioArgs': {'submissionId':draftSubmissionId}})
    * def locationId = getStepVariable('PolicyCommon.GetPolicyLocationId','locationid')
    And step('BAJob.CreateBusinessVehicle',{'templateArgs': {'locationId':locationId ,'vehicleVIN': 'VIN12345'}, 'scenarioArgs': {'submissionId':draftSubmissionId} })
    * def vehicleId = getStepVariable('BAJob.CreateBusinessVehicle','vehicleId')
    And step('BAJob.SyncLineItems', {'scenarioArgs': {'submissionId':draftSubmissionId,'syncType':'Coverages'}})
    And step('PolicyCommon.QuotePolicy', {'scenarioArgs': {'submissionId':draftSubmissionId}})
    And step('JobCommon.MakeDraftJob', {'scenarioArgs': {'jobId':draftSubmissionId}})
    And step('BAJob.CreateBusinessVehicle',{'templateArgs': {'locationId':locationId,'vehicleVIN': 'VIN2345'}, 'scenarioArgs': {'submissionId':draftSubmissionId} })
    * def vehicleId = getStepVariable('BAJob.CreateBusinessVehicle','vehicleId')
    And step('BAJob.SyncLineItems', {'scenarioArgs': {'submissionId':draftSubmissionId,'syncType':'Coverages'}})
    And step('PolicyCommon.QuotePolicy', {'scenarioArgs': {'submissionId':draftSubmissionId}})
    And step('PolicyCommon.WithdrawPolicy', {'scenarioArgs': {'submissionId':draftSubmissionId}})
    Then step('JobCommon.ValidateJobStatus', {'scenarioArgs': {'jobId':draftSubmissionId, 'jobStatus':'Withdrawn', 'jobType':'Submission'}})

   @id=CADecline
   Scenario: Execute Commercial Auto Quote and Decline a submission
     Given step('Accounts.AddCompany', {'templateArgs': {}})
     * def companyId = getStepVariable('Accounts.AddCompany', 'id')
     And step('BAJob.CreateBasicDraftBusinessAutoSubmission', {'templateArgs': {'companyId': companyId, 'jobEffectiveDate': jobEffectiveDate}})
     * def draftSubmissionId = getStepVariable('PolicyCommon.SubmitPolicy','submissionId')
     When step('PolicyCommon.QuotePolicy', {'scenarioArgs': {'submissionId':draftSubmissionId}})
     And step('JobCommon.DeclineJob', {'scenarioArgs': {'jobId':draftSubmissionId}, 'templateArgs': {'reason':'PaymentHistory', 'reasonText':'The Payments had NSF'}})
     Then step('JobCommon.ValidateJobStatus', {'scenarioArgs': {'jobId':draftSubmissionId, 'jobStatus':'Declined', 'jobType':'Submission'}})
     And step('JobCommon.VerifyCannotMakeDraftJob', {'scenarioArgs': {'jobId':draftSubmissionId, 'jobStatusDisplayName': 'Declined'}})

   @id=CANotTaken
   Scenario: Execute Commercial Auto Quote and Not-Take a submission
     Given step('Accounts.AddCompany', {'templateArgs': {}})
     * def companyId = getStepVariable('Accounts.AddCompany', 'id')
     And step('BAJob.CreateBasicDraftBusinessAutoSubmission', {'templateArgs': {'companyId': companyId, 'jobEffectiveDate': jobEffectiveDate}})
     * def draftSubmissionId = getStepVariable('PolicyCommon.SubmitPolicy','submissionId')
     * def locationId = getStepVariable('PolicyCommon.GetPolicyLocationId','locationid')
     When step('PolicyCommon.QuotePolicy', {'scenarioArgs': {'submissionId':draftSubmissionId}})
     And step('JobCommon.NotTakenJob', {'scenarioArgs': {'jobId':draftSubmissionId}, 'templateArgs': {'reason':'noc', 'reasonText':'Premium too high'}})
     Then step('JobCommon.ValidateJobStatus', {'scenarioArgs': {'jobId':draftSubmissionId, 'jobStatus':'NotTaken', 'jobType':'Submission'}})
     And step('JobCommon.VerifyCannotMakeDraftJob', {'scenarioArgs': {'jobId':draftSubmissionId, 'jobStatusDisplayName': 'Not-taken'}})
     And step('BAJob.VerifyCannotAddBusinessAutoVehicle',{'templateArgs': {'locationId':locationId,'vehicleVIN': '67890CannotCreate'}, 'scenarioArgs': {'submissionId':draftSubmissionId} })