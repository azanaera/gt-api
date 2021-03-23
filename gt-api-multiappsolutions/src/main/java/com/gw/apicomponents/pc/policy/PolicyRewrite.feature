Feature: As a user, I want to rewrite a policy

  Background:
    * def policyPath = 'classpath:com/gw/apicomponents/pc/policy/'
    * def jobUrl = pcBaseUrl + '/rest/job/v1/jobs'
    * def policyBaseUrl = pcBaseUrl + '/rest/policy/v1/policies'
    * configure headers = read('classpath:headers.js')

  @id=RewritePolicy
  Scenario: Rewrite Policy
    * def requiredArguments = ['policyId']
    * def rewritePolicyTemplate = policyPath + 'rewritePolicy.json'
    * def policyUrl = policyBaseUrl + "/" + __arg.scenarioArgs.policyId + '/rewrite'
    Given url policyUrl
    And request readWithArgs(rewritePolicyTemplate,  __arg.templateArgs)
    When method POST
    Then status 201
    And setStepVariable('rewriteJobId', response.data.attributes.id)
