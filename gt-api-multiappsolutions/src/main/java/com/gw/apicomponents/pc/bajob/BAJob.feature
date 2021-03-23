Feature: As a user, I want to modify a job

  Background:
    * def username = policyusername
    * def password = policypassword
    * def sharedPath = 'classpath:com/gw/apicomponents/pc/bajob/'
    * def emptyJsonPath = 'classpath:com/gw/apicomponents/pc/policy/'
    * def jobUrl = pcBaseUrl + '/rest/job/v1/jobs'
    * def policyBaseUrl = pcBaseUrl + '/rest/policy/v1/policies'

    * configure headers = read('classpath:headers.js')

  @id=PatchBusinessAutoPolicyType
  Scenario: Patch Business Auto Policy
    * def requiredArguments = ['submissionId']
    * def patchBusinessAutoLineTemplate = sharedPath + 'patchBusinessAutoLine.json'
    * def baPolicyPatchUrl = jobUrl +  "/" + __arg.scenarioArgs.submissionId + '/lines/BusinessAutoLine'
    Given url baPolicyPatchUrl
    And request readWithArgs(patchBusinessAutoLineTemplate,  __arg.templateArgs)
    When method PATCH
    Then status 200

  @id=AddCoverage
  Scenario: Add Business Auto Policy Coverage
    * def requiredArguments = ['submissionId','coverageType','coverable','id']
    * def covUrl =
    """
      function(coverable) {
        switch(coverable) {
          case 'Line':
            return (jobUrl +  "/" + __arg.scenarioArgs.submissionId + '/lines/BusinessAutoLine/coverages');
          case 'Jurisdiction':
            return (jobUrl +  "/" + __arg.scenarioArgs.submissionId + '/lines/BusinessAutoLine/ba-jurisdictions/' + __arg.scenarioArgs.id + '/coverages');
          case 'Vehicle':
             return (jobUrl +  "/" + __arg.scenarioArgs.submissionId + '/lines/BusinessAutoLine/business-vehicles/' + __arg.scenarioArgs.id + '/coverages');
          case 'Vehicle Addl Interests':
            return (jobUrl +  "/" + __arg.scenarioArgs.submissionId + '/lines/BusinessAutoLine/business-vehicles/' + __arg.scenarioArgs.id + '/ba-vhcle-addl-interests');
          default:
           throw 'Unknown Coverable: ' + coverable;
       }
     }
    """
    * def requestPayLoad =
    """
      function(coverageType) {
        switch(coverageType) {
          case 'Additional Coverage':
            return (sharedPath + 'addBALineAdditionalCov.json');
          case 'Line Coverage':
            return (sharedPath + 'addBACoverage.json');
          case 'Seasonal Coverage':
             return (sharedPath + 'addBASeaonTrailerLiabCov.json');
          case 'Hired Auto Coverage':
             return (sharedPath + 'addBAHiredAutoCov.json');
          case 'Vehicle Addl Interests':
             return (sharedPath + 'addBAVehicleAddlInterests.json');
          default:
           throw 'Unknown Coverage Type: ' + coverageType;
       }
     }
    """
    Given url covUrl(__arg.scenarioArgs.coverable)
    And request readWithArgs(requestPayLoad(__arg.scenarioArgs.coverageType),  __arg.templateArgs)
    When method POST
    Then status 201

  @id=CreateBusinessVehicle
  Scenario: Create a Business Auto Vehicle
    * def requiredArguments = ['submissionId']
    * def addBusinessVehicleTemplate = sharedPath + 'addBusinessVehicle.json'
    * def businessVehicleUrl = jobUrl +  "/" + __arg.scenarioArgs.submissionId + '/lines/BusinessAutoLine/business-vehicles'
    Given url businessVehicleUrl
    And request readWithArgs(addBusinessVehicleTemplate,  __arg.templateArgs)
    When method POST
    Then status 201
    And setStepVariable('vehicleId', response.data.attributes.id)

  @id=AddBAHiredAutoJurisdiction
  Scenario: Add Business Auto Policy Hired Auto Jurisdiction
    * def requiredArguments = ['submissionId']
    * def addBAHiredAutoJurisdiction = sharedPath + 'addBAHiredAutoJurisdiction.json'
    * def addBAHiredAutoJurisdictionUrl = jobUrl +  "/" + __arg.scenarioArgs.submissionId + '/lines/BusinessAutoLine/ba-jurisdictions'
    Given url addBAHiredAutoJurisdictionUrl
    And request readWithArgs(addBAHiredAutoJurisdiction,  __arg.templateArgs)
    When method POST
    Then status 201
    And setStepVariable('jurisdictionId', response.data.attributes.id)

  @id=AddBAHiredAutoJurisdictionCoverage
  Scenario: Add Business Auto Policy Hired Auto Jurisdiction
    * def requiredArguments = ['submissionId','jurisdictionId']
    * def addBAHiredAutoJurisdictionCoverage = sharedPath + 'addBAHiredAutoJurisdictionCov.json'
    * def baPolicyHiredAutoJurisdictionCoverageUrl = jobUrl +  "/" + __arg.scenarioArgs.submissionId + '/lines/BusinessAutoLine/ba-jurisdictions' +  "/" + __arg.scenarioArgs.jurisdictionId + '/ba-hired-auto-bases'
    Given url baPolicyHiredAutoJurisdictionCoverageUrl
    And request readWithArgs(addBAHiredAutoJurisdictionCoverage,  __arg.templateArgs)
    When method POST
    Then status 201

  @id=DeleteBAVehicle
  Scenario: Delete Business Auto Policy Vehicle Coverage
    * def requiredArguments =  ['submissionId','vehicleId']
    * def emptyRequestTemplate = emptyJsonPath + 'emptyRequest.json'
    * def deleteBALineVehicleUrl = jobUrl +  "/" + __arg.scenarioArgs.submissionId + '/lines/BusinessAutoLine/business-vehicles/' + __arg.scenarioArgs.vehicleId
    Given url deleteBALineVehicleUrl
    And request read(emptyRequestTemplate)
    When method DELETE
    Then status 204

  @id=AddBAModifiers
  Scenario: Add Business Auto Policy Modifiers
    * def requiredArguments = ['submissionId','modifier']
    * def addBAModifierUrl = jobUrl +  "/" + __arg.scenarioArgs.submissionId + '/lines/BusinessAutoLine/modifiers/' + __arg.scenarioArgs.modifier
    * def addBAModifier = sharedPath + 'addBAModifier.json'
    Given url addBAModifierUrl
    And request readWithArgs(addBAModifier,  __arg.templateArgs)
    When method PATCH
    Then status 200

  @id=GetFirstBAVehicle
  Scenario: Get Business Auto Policy First Vehicle
    * def requiredArguments = ['submissionId']
    * def getBAVehicleUrl = jobUrl +  "/" + __arg.scenarioArgs.submissionId + '/lines/BusinessAutoLine/business-vehicles'
    * def emptyRequestTemplate = emptyJsonPath + 'emptyRequest.json'
    Given url getBAVehicleUrl
    And request read(emptyRequestTemplate)
    When method GET
    Then status 200
    And setStepVariable('vehicleId', response.data[0].attributes.id)

  @id=VerifyCannotAddBusinessAutoVehicle
  Scenario: Verify Cannot Add Business Auto Vehicle for a job in the wrong status
    * def requiredArguments = ['submissionId']
    * def addBusinessVehicleTemplate = sharedPath + 'addBusinessVehicle.json'
    * def businessVehicleUrl = jobUrl +  "/" + __arg.scenarioArgs.submissionId + '/lines/BusinessAutoLine/business-vehicles'
    Given url businessVehicleUrl
    And request readWithArgs(addBusinessVehicleTemplate,  __arg.templateArgs)
    When method POST
    Then status 400
    And match response.errorCode == 'gw.api.rest.exceptions.BadInputException'
    And match response.userMessage == 'Cannot add new BusinessVehicle to collection business-vehicles'
    And match response.details[0].message contains 'Cannot modify locked branch'

  @id=SyncLineItems
  Scenario: Sync a Business Auto Line Policy Coverages and Modifiers
    * def requiredArguments = ['submissionId','syncType']
    * def emptyRequestTemplate = emptyJsonPath + 'emptyRequest.json'
    * def syncLineUrl = jobUrl +  "/" + __arg.scenarioArgs.submissionId + '/lines/BusinessAutoLine/'
    * def syncUrl =
    """
      function(syncType) {
        switch(syncType) {
          case 'Coverages':
            return 'sync-coverages';
          case 'Modifiers':
            return 'sync-modifiers';
          default:
           throw 'Unknown Sync Type: ' + syncType;
       }
     }
    """
    Given url syncLineUrl + syncUrl(__arg.scenarioArgs.syncType)
    And request read(emptyRequestTemplate)
    When method POST
    Then status 200

  @id=CreateBasicDraftBusinessAutoSubmission
  Scenario: Create a Basic Draft Business Auto submission
    Given step('PolicyCommon.SubmitPolicy', {'templateArgs': __arg.templateArgs })
    * def draftSubmissionId = getStepVariable('PolicyCommon.SubmitPolicy','submissionId')
    And step('BAJob.PatchBusinessAutoPolicyType', {'templateArgs': { }, 'scenarioArgs': {'submissionId':draftSubmissionId}})
    And step('PolicyCommon.GetPolicyLocationId', {'scenarioArgs': {'submissionId':draftSubmissionId}})
    * def locationId = getStepVariable('PolicyCommon.GetPolicyLocationId','locationid')
    And step('BAJob.CreateBusinessVehicle',{'templateArgs': {'locationId':locationId,'vehicleVIN': '12345'}, 'scenarioArgs': {'submissionId':draftSubmissionId} })
    * def vehicleId = getStepVariable('BAJob.CreateBusinessVehicle','vehicleId')
    And step('BAJob.SyncLineItems', {'scenarioArgs': {'submissionId':draftSubmissionId,'syncType':'Coverages'}})
