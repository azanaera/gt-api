# Note: These test scenarios are included for illustrative purposes only
# and are dependent on appropriate line of business setup.
@RunAll
Feature: As an underwriter I want to test the Commercial Auto Policy Life Cycle

  Background:
     Given step('CreatePolicyAdminData.PCAdminData')
     * def underwriter = policyDataContainer.getPolicyUser("pcunderwriter")
     * def username = underwriter.getName()
     * def password = 'gw'
     * def policyUrl = pcBaseUrl + '/rest/job/v1/jobs'
     * def commonUrl = pcBaseUrl + '/rest/common/v1'
     * def jobEffectiveDate = policyUtil.currentISODateString()
     * configure headers = read('classpath:headers.js')

    @id=CALifecycle
    Scenario: Execute Commercial Auto Policy LifeCycle
      * def getAccountId =
      """
        function(){
            if(typeof __arg !== 'undefined' && __arg !== null && __arg.scenarioArgs!=='undefined' && isObjectKeyExists(__arg.scenarioArgs,'accountId')){
                 return __arg.scenarioArgs.accountId;
           } else {
                step('Accounts.AddCompany', {'templateArgs': {}});
                return getStepVariable('Accounts.AddCompany', 'id');
           }
        }
      """

      * def companyId = getAccountId()
      When step('PolicyCommon.SubmitPolicy', {'templateArgs': {'companyId': companyId, 'jobEffectiveDate': jobEffectiveDate}})
      * def draftSubmissionId = getStepVariable('PolicyCommon.SubmitPolicy','submissionId')
      And step('BAJob.PatchBusinessAutoPolicyType', {'templateArgs': { }, 'scenarioArgs': {'submissionId':draftSubmissionId}})
      And step('PolicyCommon.GetPolicyLocationId', {'scenarioArgs': {'submissionId':draftSubmissionId}})
      * def locationId = getStepVariable('PolicyCommon.GetPolicyLocationId','locationid')
      And step('BAJob.CreateBusinessVehicle',{'templateArgs': {'locationId':locationId,'vehicleVIN': '12345'}, 'scenarioArgs': {'submissionId':draftSubmissionId} })
      * def vehicleId = getStepVariable('BAJob.CreateBusinessVehicle','vehicleId')
      And step('BAJob.SyncLineItems', {'scenarioArgs': {'submissionId':draftSubmissionId,'syncType':'Coverages'}})
      And step('PolicyCommon.QuotePolicy', {'scenarioArgs': {'submissionId':draftSubmissionId}})
      And step('JobCommon.BindAndIssueJob', {'scenarioArgs': {'jobId':draftSubmissionId}})
      * def policyId = getStepVariable('JobCommon.BindAndIssueJob','policyId')
      Then step('JobCommon.ValidateJobStatus', {'scenarioArgs': {'jobId':draftSubmissionId, 'jobStatus':'Bound', 'jobType':'Submission'}})
      And step('JobCommon.ValidatePolicyIsIssued', {'scenarioArgs': {'policyId': policyId}})
