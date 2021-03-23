# Note: These test scenarios are included for illustrative purposes only
# and are dependent on appropriate line of business setup.
@RunAll
Feature:  As an underwriter I want to test the Commercial Auto Policy Rewrite Scenario

  Background:
     Given step('CreatePolicyAdminData.PCAdminData')
     * def underwriter = policyDataContainer.getPolicyUser("pcunderwriter")
     * def username = underwriter.getName()
     * def password = 'gw'
     * def jobEffectiveDate = policyUtil.currentISODateString()
     * def jobEffectiveDateMidTerm = policyUtil.addMonthsToISODateString(jobEffectiveDate, 3)
     * def jobEffectiveDateTermChange = policyUtil.addMonthsToISODateString(jobEffectiveDate, 9)
     * configure headers = read('classpath:headers.js')

   @id=CARewriteRemainderTerm
   Scenario: Execute Commercial Auto Policy Rewrite Remainder Term
     Given step('Accounts.AddCompany', {'templateArgs': {'accountContactCompanyName': 'Rewrite Remainder Company'}})
     And step('RunCAPolicyLifecycle.CALifecycle', {'scenarioArgs': {'accountId':getStepVariable('Accounts.AddCompany', 'id')}})
     And step('PolicyCancel.CancelPolicy', {'scenarioArgs': {'policyId': getStepVariable('JobCommon.BindAndIssueJob','policyId')}, 'templateArgs': {'reason': 'midtermrewrite', 'source': 'carrier', 'jobEffectiveDate': jobEffectiveDateMidTerm}})
     And step('JobCommon.BindAndIssueJob', {'scenarioArgs': {'jobId':getStepVariable('PolicyCancel.CancelPolicy','cancelJobId')}})
     And step('PolicyRewrite.RewritePolicy', {'scenarioArgs': {'policyId': getStepVariable('JobCommon.BindAndIssueJob','policyId')}, 'templateArgs': {'rewriteCode': 'RewriteRemainderOfTerm'}})
     And step('PolicyCommon.QuotePolicy', {'scenarioArgs': {'submissionId':getStepVariable('PolicyRewrite.RewritePolicy','rewriteJobId')}})
     * def quoteId = getStepVariable('PolicyCommon.QuotePolicy','jobId')
     Then step('JobCommon.ValidateJobStatus', {'scenarioArgs': {'jobId':quoteId, 'jobStatus':'Quoted', 'jobType':'Rewrite'}})
     And step('JobCommon.BindAndIssueJob', {'scenarioArgs': {'jobId':quoteId}})
     And step('JobCommon.ValidatePolicyIsIssued', {'scenarioArgs': {'policyId': getStepVariable('JobCommon.BindAndIssueJob','policyId')}})

   @id=CARewriteNewTerm
   Scenario: Execute Commercial Auto Policy Rewrite New Term
     Given step('Accounts.AddCompany', {'templateArgs': {'accountContactCompanyName': 'Rewrite New Company'}})
     And step('RunCAPolicyLifecycle.CALifecycle', {'scenarioArgs': {'accountId':getStepVariable('Accounts.AddCompany', 'id')}})
     And step('PolicyCancel.CancelPolicy', {'scenarioArgs': {'policyId': getStepVariable('JobCommon.BindAndIssueJob','policyId')}, 'templateArgs': {'reason': 'midtermrewrite', 'source': 'carrier', 'jobEffectiveDate': jobEffectiveDateMidTerm}})
     And step('JobCommon.BindAndIssueJob', {'scenarioArgs': {'jobId':getStepVariable('PolicyCancel.CancelPolicy','cancelJobId')}})
     And step('PolicyRewrite.RewritePolicy', {'scenarioArgs': {'policyId': getStepVariable('JobCommon.BindAndIssueJob','policyId')}, 'templateArgs': {'rewriteCode': 'RewriteNewTerm'}})
     * def rewriteJobId = getStepVariable('PolicyRewrite.RewritePolicy','rewriteJobId')
     And step('BAJob.AddCoverage', {'scenarioArgs': {'submissionId':rewriteJobId,'coverageType':'Line Coverage','coverable':'Line','id':''},'templateArgs': {'coverageId': 'BABobtailLiabCov'}})
     And step('PolicyCommon.QuotePolicy', {'scenarioArgs': {'submissionId':rewriteJobId}})
     Then step('JobCommon.ValidateJobStatus', {'scenarioArgs': {'jobId':getStepVariable('PolicyCommon.QuotePolicy','jobId'), 'jobStatus':'Quoted', 'jobType':'Rewrite'}})

   @id=CARewriteFullTermWithdraw
   Scenario: Execute Commercial Auto Policy Rewrite Full Term and Withdraw
     Given step('Accounts.AddCompany', {'templateArgs': {'accountContactCompanyName': 'Rewrite Full Company'}})
     And step('RunCAPolicyLifecycle.CALifecycle', {'scenarioArgs': {'accountId':getStepVariable('Accounts.AddCompany', 'id')}})
     And step('PolicyCancel.CancelPolicy', {'scenarioArgs': {'policyId': getStepVariable('JobCommon.BindAndIssueJob','policyId')}, 'templateArgs': {'reason': 'nottaken', 'source': 'insured', 'jobEffectiveDate': jobEffectiveDate}})
     And step('JobCommon.BindAndIssueJob', {'scenarioArgs': {'jobId':getStepVariable('PolicyCancel.CancelPolicy','cancelJobId')}})
     And step('PolicyRewrite.RewritePolicy', {'scenarioArgs': {'policyId': getStepVariable('JobCommon.BindAndIssueJob','policyId')}, 'templateArgs': {'rewriteCode': 'RewriteFullTerm'}})
     * def rewriteJobId = getStepVariable('PolicyRewrite.RewritePolicy','rewriteJobId')
     And step('PolicyCommon.WithdrawPolicy', {'scenarioArgs': {'submissionId':rewriteJobId}})
     Then step('JobCommon.ValidateJobStatus', {'scenarioArgs': {'jobId':getStepVariable('PolicyCommon.WithdrawPolicy','jobId'), 'jobStatus':'Withdrawn', 'jobType':'Rewrite'}})

   @id=CAChangeRewriteNewTerm
   Scenario: Execute Commercial Auto Policy Rewrite New Term Change
     Given step('Accounts.AddCompany', {'templateArgs': {'accountContactCompanyName': 'Rewrite Change Company'}})
     And step('RunCAPolicyLifecycle.CALifecycle', {'scenarioArgs': {'accountId':getStepVariable('Accounts.AddCompany', 'id')}})
     And step('PolicyCancel.CancelPolicy', {'scenarioArgs': {'policyId': getStepVariable('JobCommon.BindAndIssueJob','policyId')}, 'templateArgs': {'reason': 'midtermrewrite', 'source': 'carrier', 'jobEffectiveDate': jobEffectiveDateTermChange}})
     And step('JobCommon.BindAndIssueJob', {'scenarioArgs': {'jobId':getStepVariable('PolicyCancel.CancelPolicy','cancelJobId')}})
     And step('PolicyRewrite.RewritePolicy', {'scenarioArgs': {'policyId': getStepVariable('JobCommon.BindAndIssueJob','policyId')}, 'templateArgs': {'rewriteCode': 'RewriteNewTerm'}})
     * def rewriteJobId = getStepVariable('PolicyRewrite.RewritePolicy','rewriteJobId')
     And step('JobCommon.PatchJob', {'scenarioArgs': {'jobId':rewriteJobId}, 'templateArgs': {'termTypeCode': 'Other'}})
     And step('PolicyCommon.QuotePolicy', {'scenarioArgs': {'submissionId':rewriteJobId}})
     * def quoteId = getStepVariable('PolicyCommon.QuotePolicy','jobId')
     Then step('JobCommon.ValidateJobStatus', {'scenarioArgs': {'jobId':quoteId, 'jobStatus':'Quoted', 'jobType':'Rewrite'}})
     And step('JobCommon.BindAndIssueJob', {'scenarioArgs': {'jobId':quoteId}})
     And step('JobCommon.ValidatePolicyIsIssued', {'scenarioArgs': {'policyId': getStepVariable('JobCommon.BindAndIssueJob','policyId')}})
