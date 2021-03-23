Feature: Create CC Standalone Policy

  Background:
    Given step('CreateClaimAdminData.CCAdminData')
    * def ccBaseUrl = ccBaseUrl
    * def claimsUrl = ccBaseUrl + '/rest/claim/v1/claims'
    * def commonUrl = ccBaseUrl + '/rest/common/v1'
    * configure headers = read('classpath:headers.js')

  Scenario: Execute scenarios in sequence
    Given step('Policies.CreatePolicy', {'scenarioArgs': {'lineOfBusiness': 'PersonalAuto'}, 'templateArgs': {}})
    * def PAPolicyNumber = getStepVariable('Policies.CreatePolicy','policyNumber')
    * def Insured = getStepVariable('Policies.CreatePolicy','insured')