Feature: Service Request Quotes
  As an adjuster I want to perform actions on service request quotes

  @id=AddQuote
  Scenario: Add a quote for service request on a claim
    * def requiredArguments = ['claimId', 'serviceRequestId']
    * def addQuoteTemplate = 'classpath:com/gw/apicomponents/services/addQuote.json'
    * def addQuoteUrl = claimsUrl + '/' + __arg.scenarioArgs.claimId + '/service-requests/'+ __arg.scenarioArgs.serviceRequestId + '/add-quote'
    Given url addQuoteUrl
    And request readWithArgs(addQuoteTemplate, __arg.templateArgs)
    When method POST
    Then status 200
    * match response.data.attributes.latestQuote.subtype.code == "ServiceRequestQuote"
    * match response.data.attributes.latestQuote.description == __arg.templateArgs.description
    * match response.data.attributes.latestQuote.expectedDaysToPerformService == __arg.templateArgs.expectedDays
    * match response.data.attributes.latestQuote.lineItems[0].amount.amount == __arg.templateArgs.amount
    * match response.data.attributes.latestQuote.total.amount == __arg.templateArgs.amount
    * match response.data.attributes.latestQuote.referenceNumber == __arg.templateArgs.refNum
    * setStepVariable('quoteId', response.data.attributes.latestQuote.id)

  @id=ApproveQuote
  Scenario: Approve quote
    * def requiredArguments = ['claimId', 'serviceRequestId', 'quoteId']
    * def approveQuoteTemplate = 'classpath:com/gw/apicomponents/services/approveQuote.json'
    * def approveQuoteUrl = claimsUrl + '/' + __arg.scenarioArgs.claimId + '/service-requests/'+ __arg.scenarioArgs.serviceRequestId + '/quotes/' + __arg.scenarioArgs.quoteId + '/approve'
    Given url approveQuoteUrl
    And request read(approveQuoteTemplate)
    When method POST
    Then status 200
    * match response.data.attributes.id == __arg.scenarioArgs.quoteId

  @id=GetQuote
  Scenario: Get the service request quote data
    * def requiredArguments = ['claimId', 'serviceRequestId', 'quoteId', 'amount', 'expectedDays']
    * def getQuoteUrl = claimsUrl + "/" + __arg.scenarioArgs.claimId + '/service-requests/'+ __arg.scenarioArgs.serviceRequestId + '/quotes/' + __arg.scenarioArgs.quoteId
    Given url getQuoteUrl
    When method GET
    Then status 200
    * match response.data.attributes.id == __arg.scenarioArgs.quoteId
    * match response.data.attributes.lineItems[0].amount.amount == __arg.scenarioArgs.amount
    * match response.data.attributes.expectedDaysToPerformService == __arg.scenarioArgs.expectedDays

  @id=AddInvoice
  Scenario: Add invoice for service request on a claim
    * def requiredArguments = ['claimId', 'serviceRequestId']
    * def addInvoiceTemplate = 'classpath:com/gw/apicomponents/services/addInvoice.json'
    * def addInvoiceUrl = claimsUrl + '/' + __arg.scenarioArgs.claimId + '/service-requests/'+ __arg.scenarioArgs.serviceRequestId + '/invoices'
    Given url addInvoiceUrl
    And request readWithArgs(addInvoiceTemplate, __arg.templateArgs)
    When method POST
    Then status 201
    * setStepVariable('invoiceId', response.data.attributes.id)
    * match response.data.attributes.lineItems[0].amount.amount == __arg.templateArgs.amount
    * match response.data.attributes.description == __arg.templateArgs.description

  @id=GetInvoice
  Scenario: Get invoice data
    * def requiredArguments = ['claimId', 'serviceRequestId', 'invoiceId']
    * def invoiceUrl = claimsUrl + '/' + __arg.scenarioArgs.claimId + '/service-requests/'+ __arg.scenarioArgs.serviceRequestId + '/invoices/' + __arg.scenarioArgs.invoiceId
    Given url invoiceUrl
    When method GET
    Then status 200
    * match response.data.attributes.id == __arg.scenarioArgs.invoiceId
    * match response.data.attributes.lineItems[0].amount.amount == __arg.scenarioArgs.amount
    * match response.data.attributes.description == __arg.scenarioArgs.description