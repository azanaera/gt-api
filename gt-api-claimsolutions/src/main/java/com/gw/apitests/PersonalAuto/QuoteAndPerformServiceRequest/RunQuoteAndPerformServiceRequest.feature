# Note: These test scenarios are included for illustrative purposes only and are
# dependent on the TestSupport APIs and the ClaimServicingApis being enabled.
Feature: Service request
  As an adjuster I want to create a personal auto claim, incident, exposure and reserve line for it, add an exposure related 'Quote And Perform Service' request,
  add a quote, approve quote, add invoice, complete service request, then close the claim

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
    * def reserve = {'amount': '500.00', 'currency': 'usd', 'costTypeCode': 'claimcost'}
    * def quoteNumber = ccUtilities.addRandomInt('quoteTestRef-')
    * def quote = {'refNum': '#(quoteNumber)', 'description': 'Quote for headlight replacement', 'expectedDays': 5, 'amount': '200.00', 'currency': 'usd'}
    * def invoiceNumber = ccUtilities.addRandomInt('invoiceTestRef-')
    * def invoice = {'refNum': '#(invoiceNumber)', 'description': 'Invoice for headlight replacement', 'amount': '200.00', 'currency': 'usd'}

  @RunAll
  @id=RunPAQuoteAndPerformServiceRequest
  Scenario: Quote-and-Perform-Service request life cycle

  #  Create a policy and a claim
    Given step('Policies.CreatePolicy', {'scenarioArgs': {'lineOfBusiness': 'PersonalAuto'}, 'templateArgs': {}})
    * def PAPolicyNumber = getStepVariable('Policies.CreatePolicy','policyNumber')
    When step('Claims.CreateClaim', {'scenarioArgs': {'lineOfBusiness': 'PersonalAuto'},'templateArgs': {'policyNumber': PAPolicyNumber}})
    * def claimId = getStepVariable('Claims.CreateClaim','claimId')
    And step('Claims.SubmitClaim', {'scenarioArgs': {'draftClaimId': claimId}, 'templateArgs':{'groupId': adjuster.getGroupId(),'userId': adjuster.getId()}})
    * def insuredId = getStepVariable('Claims.SubmitClaim','insuredId')

  #  Create incident, exposure and reserve
    And step('Incidents.CreateVehicleIncident', {'scenarioArgs':{'claimId': claimId}, 'templateArgs': {'insuredId': insuredId}})
    * def incidentId = getStepVariable('Incidents.CreateVehicleIncident','incidentId')
    And step('Exposures.CreateVehicleIncidentExposure', {'scenarioArgs': {'claimId': claimId}, 'templateArgs': {'insuredId': insuredId, 'incidentId': incidentId}})
    * def exposureId = getStepVariable('Exposures.CreateVehicleIncidentExposure','exposureId')

  #  Create a vendor specialist and a quote-and-perform service request
    And step('SpecialistService.CreateSpecialistService', {'templateArgs': {'code': serviceCode}})
    * def specialistServiceId = getStepVariable('SpecialistService.CreateSpecialistService','specialistServiceId')
    * def newSpecialistUri = "/claim/v1/claims/" + claimId + "/contacts"
    And step('Services.CreateRequestForExposure', {'scenarioArgs':{'claimId': claimId}, 'templateArgs': {'customerId': insuredId, 'refNum': refNum, 'serviceCode': serviceCode, 'newSpecialistUri': newSpecialistUri, 'kindCode': 'quoteandservice', 'exposureId': exposureId, 'incidentId': incidentId}})
    * def serviceId = getStepVariable('Services.CreateRequestForExposure','serviceRequestId')
    And step('Services.SubmitServiceRequest', {'scenarioArgs': {'claimId': claimId, 'serviceRequestId': serviceId}})

  #  Get the service request and verify its status
    And step('Services.GetServiceRequest', {'scenarioArgs': {'claimId': claimId, 'serviceRequestId': serviceId}})
    And step('Services.VerifyServiceRequest', {'scenarioArgs': {'actualServiceRequest': getStepResponse('Services.GetServiceRequest'), 'expectedProgress': 'Requested', 'expectedNextStep': 'Agree to provide quote'}})

  #  Add a quote to the service request, Approve quote, Get quote
    And step('QuotesAndInvoices.AddQuote', {'scenarioArgs': {'claimId': claimId, 'serviceRequestId': serviceId}, 'templateArgs': {'description': quote.description, 'expectedDays': quote.expectedDays, 'amount': quote.amount, 'currency': quote.currency, 'refNum': quote.refNum}})
    * def quoteId = getStepVariable('QuotesAndInvoices.AddQuote','quoteId')
    And step('QuotesAndInvoices.ApproveQuote', {'scenarioArgs': {'claimId': claimId, 'serviceRequestId': serviceId, 'quoteId': quoteId}})
    And step('QuotesAndInvoices.GetQuote', {'scenarioArgs': {'claimId': claimId, 'serviceRequestId': serviceId, 'quoteId': quoteId, 'amount': quote.amount, 'expectedDays': quote.expectedDays}})

  #  Get the service request and verify its status after quote is submitted
    And step('Services.GetServiceRequest', {'scenarioArgs': {'claimId': claimId, 'serviceRequestId': serviceId}})
    And step('Services.VerifyServiceRequest', {'scenarioArgs': {'actualServiceRequest': getStepResponse('Services.GetServiceRequest'), 'expectedProgress': 'In Progress', 'expectedNextStep': 'Finish the work'}})

  #  Add invoice, Get invoice
    And step('QuotesAndInvoices.AddInvoice', {'scenarioArgs': {'claimId': claimId, 'serviceRequestId': serviceId}, 'templateArgs': {'description': invoice.description, 'amount': invoice.amount, 'currency': invoice.currency, 'refNum': invoice.refNum}})
    * def invoiceId = getStepVariable('QuotesAndInvoices.AddInvoice','invoiceId')
    And step('QuotesAndInvoices.GetInvoice', {'scenarioArgs': {'claimId': claimId, 'serviceRequestId': serviceId, 'invoiceId': invoiceId, 'amount': invoice.amount, 'description': invoice.description}})

  # Complete Service Request
    And step('Services.CompleteServiceRequest', {'scenarioArgs': {'claimId': claimId, 'serviceRequestId': serviceId}})

  #  Get the service request and verify its status
    And step('Services.GetServiceRequest', {'scenarioArgs': {'claimId': claimId, 'serviceRequestId': serviceId}})
    And step('Services.VerifyServiceRequest', {'scenarioArgs': {'actualServiceRequest': getStepResponse('Services.GetServiceRequest'), 'expectedProgress': 'Work Complete', 'expectedNextStep': 'Pay invoice'}})

  #  Close all activities, exposure and the claim after service is complete
    And step('Activities.CloseAllActivities',{'scenarioArgs': {'claimId': claimId}})
    And step('Exposures.CloseExposure', {'scenarioArgs': {'claimId': claimId, 'exposureId': exposureId}})
    Then step('Claims.CloseClaim', {'scenarioArgs': {'claimId': claimId}})