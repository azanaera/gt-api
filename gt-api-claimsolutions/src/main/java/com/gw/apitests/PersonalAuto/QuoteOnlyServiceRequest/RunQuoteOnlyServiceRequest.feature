# Note: These test scenarios are included for illustrative purposes only and are
# dependent on the TestSupport APIs and the ClaimServicingApis being enabled.
Feature: Service request
  As an adjuster I want to create a personal auto claim, add an incident related 'Quote only' type service request,
  create a company vendor contact as the service specialist, create specialist service and its code, request service from the vendor, add a quote,
  verify service is completed after quote is submitted, then close all activities and the claim.

  Background:
    Given step('CreateClaimAdminData.CCAdminData')
    * def adjuster = claimsDataContainer.getClaimsUser("ccadjuster1")
    * def username = adjuster.getName()
    * def password = claimsDataContainer.getPassword()
    * def claimsUrl = ccBaseUrl + '/rest/claim/v1/claims'
    * def commonUrl = ccBaseUrl + '/rest/common/v1'
    * configure headers = read('classpath:headers.js')
    * def ccUtilities = claimUtils
    * def serviceCode = ccUtilities.addRandomInt("service-")
    * def refNum = ccUtilities.addRandomInt("testRef-")
    * def quoteRefNum = ccUtilities.addRandomInt("quoteTestRef-")
    * def quoteDescription = "Quote for headlight replacement"
    * def quoteExpectedDays = 5
    * def quoteAmount = "200.00"
    * def quoteCurrency = "usd"

  @RunAll
  @id=RunPAQuoteOnlyServiceRequest
  Scenario: Quote-only service request life cycle

  #  Create a claim and an incident
    Given step('Policies.CreatePolicy', {'scenarioArgs': {'lineOfBusiness': 'PersonalAuto'}, 'templateArgs': {}})
    * def PAPolicyNumber = getStepVariable('Policies.CreatePolicy','policyNumber')
    When step('Claims.CreateClaim', {'scenarioArgs': {'lineOfBusiness': 'PersonalAuto'},'templateArgs': {'policyNumber': PAPolicyNumber}})
    * def claimId = getStepVariable('Claims.CreateClaim','claimId')
    And step('Claims.SubmitClaim', {'scenarioArgs': {'draftClaimId': claimId}, 'templateArgs':{'groupId': adjuster.getGroupId(),'userId': adjuster.getId()}})
    * def insuredId = getStepVariable('Claims.SubmitClaim','insuredId')
    And step('Incidents.CreateVehicleIncident', {'scenarioArgs':{'claimId': claimId}, 'templateArgs': {'insuredId': insuredId}})
    * def incidentId = getStepVariable('Incidents.CreateVehicleIncident','incidentId')

  #  Create a vendor specialist and a quote-only service request
    And step('SpecialistService.CreateSpecialistService', {'templateArgs': {'code': serviceCode}})
    * def specialistServiceId = getStepVariable('SpecialistService.CreateSpecialistService','specialistServiceId')
    * def newSpecialistUri = "/claim/v1/claims/" + claimId + "/contacts"
    And step('Services.CreateRequest', {'scenarioArgs':{'claimId': claimId}, 'templateArgs': {'customerId': insuredId, 'refNum': refNum, 'serviceCode': serviceCode, 'newSpecialistUri': newSpecialistUri, 'kindCode': 'quoteonly'}})
    * def serviceId = getStepVariable('Services.CreateRequest','serviceRequestId')
    And step('Services.SubmitServiceRequest', {'scenarioArgs': {'claimId': claimId, 'serviceRequestId': serviceId}})

  #  Get the service request and verify its status
    And step('Services.GetServiceRequest', {'scenarioArgs': {'claimId': claimId, 'serviceRequestId': serviceId}})
    And step('Services.VerifyServiceRequest', {'scenarioArgs': {'actualServiceRequest': getStepResponse('Services.GetServiceRequest'), 'expectedProgress': 'Requested', 'expectedNextStep': 'Agree to provide quote'}})

  #  Add a quote to the service request
    And step('QuotesAndInvoices.AddQuote', {'scenarioArgs': {'claimId': claimId, 'serviceRequestId': serviceId}, 'templateArgs': {'description': quoteDescription, 'expectedDays': quoteExpectedDays, 'amount': quoteAmount, 'currency': quoteCurrency, 'refNum': quoteRefNum}})
    * def quoteId = getStepVariable('QuotesAndInvoices.AddQuote','quoteId')
    And step('QuotesAndInvoices.GetQuote', {'scenarioArgs': {'claimId': claimId, 'serviceRequestId': serviceId, 'quoteId': quoteId, 'amount': quoteAmount, 'expectedDays': quoteExpectedDays}})

  #  Get the service request and verify its status after quote is submitted
    And step('Services.GetServiceRequest', {'scenarioArgs': {'claimId': claimId, 'serviceRequestId': serviceId}})
    And step('Services.VerifyServiceRequest', {'scenarioArgs': {'actualServiceRequest': getStepResponse('Services.GetServiceRequest'), 'expectedProgress': 'Work Complete', 'expectedNextStep': 'None - quote submitted'}})

  #  Close all activities and the claim after service is complete
    And step('Activities.CloseAllActivities',{'scenarioArgs': {'claimId': claimId}})
    Then step('Claims.CloseClaim', {'scenarioArgs': {'claimId': claimId}})