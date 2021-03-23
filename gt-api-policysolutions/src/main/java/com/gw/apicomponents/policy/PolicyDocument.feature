Feature: As a user, I want to add documents to a policy

  Background:
    * def policyPath = 'classpath:com/gw/apicomponents/policy/'
    * def jobUrl = pcBaseUrl + '/rest/job/v1/jobs'
    * def policyBaseUrl = pcBaseUrl + '/rest/policy/v1/policies'
    * configure headers = read('classpath:headers.js')

  @id=PostPolicyDocument
  Scenario: Add a document to a Policy
    * def requiredArguments = ['policyId', 'filePath', 'fileName']
    * def postPolicyDocumentTemplate = policyPath + 'postDocument.json'
    * def postPolicyDocumentUrl = policyBaseUrl + "/" + __arg.scenarioArgs.policyId + '/documents'
    Given url postPolicyDocumentUrl
    And multipart field metadata = readWithArgs(postPolicyDocumentTemplate, __arg.templateArgs)
    And multipart file content = {read: '#(__arg.scenarioArgs.filePath)', filename: #(__arg.scenarioArgs.fileName)', contentType: "application/pdf"}
    When method POST
    Then status 201
    And setStepVariable('documentId', response.data.attributes.id)

  @id=GetPolicyDocument
  Scenario: Get a document added to a Policy
    * def requiredArguments = ['policyId', 'name']
    * def postPolicyDocumentTemplate = policyPath + 'postDocument.json'
    * def getPolicyDocumentUrl = policyBaseUrl + "/" + __arg.scenarioArgs.policyId + '/documents'
    Given url getPolicyDocumentUrl
    When method GET
    Then status 200
    And match response.data[*].attributes.name contains __arg.scenarioArgs.name

  @id=VerifyDocumentCount
  Scenario: Verify document count added to a Policy
    * def requiredArguments = ['policyId', 'count']
    * def postPolicyDocumentTemplate = policyPath + 'postDocument.json'
    * def getPolicyDocumentUrl = policyBaseUrl + "/" + __arg.scenarioArgs.policyId + '/documents'
    Given url getPolicyDocumentUrl
    When method GET
    Then status 200
    And match response.count == __arg.scenarioArgs.count