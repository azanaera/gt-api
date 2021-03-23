Feature: As a user, I want to cancel an issued policy

  Background:
    * def policyPath = 'classpath:com/gw/apicomponents/policy/'
    * def jobUrl = pcBaseUrl + '/rest/job/v1/jobs'
    * def policyBaseUrl = pcBaseUrl + '/rest/policy/v1/policies'
    * configure headers = read('classpath:headers.js')

  @id=CancelPolicy
  Scenario: Cancel a Policy
    * def requiredArguments = ['policyId']
    * def cancelPolicyTemplate = policyPath + 'cancelPolicy.json'
    * def policyUrl = policyBaseUrl + "/" + __arg.scenarioArgs.policyId + '/cancel'
    Given url policyUrl
    And request readWithArgs(cancelPolicyTemplate, __arg.templateArgs)
    When method POST
    Then status 201
    And setStepVariable('cancelJobId', response.data.attributes.id)
