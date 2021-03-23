Feature: As an adjuster I want to test the Commercial Auto Policy Life Cycle
  Background:
    * def username = enablePCTestAPIs ? policyDataContainer.getPolicyUser("pcunderwriter").getName() : 'su';
    * def password = 'gw'
    * def policyUrl = pcBaseUrl + '/rest/job/v1/jobs'
    * def commonUrl = pcBaseUrl + '/rest/common/v1'
    * def jobEffectiveDate = new Date().toISOString().split("T")[0]
    * configure headers = read('classpath:headers.js')


  @id=CALifecycleTransactionalData
  Scenario: Execute CAPolicyLifeCycle scenarios in sequence
    * def getAccountId =
      """
        function(){
            if((typeof __arg !== 'undefined' && __arg !== null && !__arg.isEmpty()) && __arg.scenarioArgs!=='undefined' && isObjectKeyExists(__arg.scenarioArgs,'accountId')){
                 return __arg.scenarioArgs.accountId;
           } else {
                step('Accounts.AddCompany', {'templateArgs': {}});
                return getStepVariable('Accounts.AddCompany', 'id');
           }
        }
      """

    * def companyId = getAccountId()
    * def accountNumber = getStepVariable('Accounts.AddCompany','accountNumber')
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
    * def policyNumber = getStepVariable('JobCommon.BindAndIssueJob','policyNumber')
    And step('JobCommon.GetContacts', {'scenarioArgs': {'jobId':policyId}})
    * def contactDisplayName = getStepVariable('JobCommon.GetContacts','contactDisplayName')