Feature: As a user, I want to renew a policy

  Background:
    * def policyPath = 'classpath:com/gw/apicomponents/policy/'
    * def jobUrl = pcBaseUrl + '/rest/job/v1/jobs'
    * def policyBaseUrl = pcBaseUrl + '/rest/policy/v1/policies'
    * configure headers = read('classpath:headers.js')

  @id=RenewPolicy
  Scenario: Renew Policy
    * def requiredArguments = ['policyId']
    * def policyUrl = policyBaseUrl + "/" + __arg.scenarioArgs.policyId + '/renew'
    Given url policyUrl
    And request read(policyPath + 'emptyRequest.json')
    When method POST
    Then status 201
    And setStepVariable('id', response.data.attributes.id)
