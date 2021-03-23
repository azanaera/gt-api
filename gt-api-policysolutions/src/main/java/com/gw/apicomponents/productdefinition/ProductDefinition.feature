Feature: Product Definition
  As a user, I want to use product definitions

  Background:
    * def productDefinitionUrl = pcBaseUrl + '/rest/productdefinition/v1'
    * def productUrl = productDefinitionUrl + '/' + 'products'
    * configure headers = read('classpath:admin-headers.js')

  @id=ProductDetails
  Scenario: View Product Details
    * def requiredArguments = ['productId']
    * def productDetailsUrl = productUrl + '/' + __arg.scenarioArgs.productId
    Given url productDetailsUrl
    When method GET
    Then status 200
    And match response.data.attributes.id == __arg.scenarioArgs.productId
    * def productAttributes =
    """
      {
        'abbreviation': #(response.data.attributes.abbreviation),
        'defaultTermType': #(response.data.attributes.defaultTermType.code),
        'description': #(response.data.attributes.description),
        'descriptionKey': #(response.data.attributes.descriptionKey),
        'id': #(response.data.attributes.id),
        'name': #(response.data.attributes.name),
        'nameKey': #(response.data.attributes.nameKey),
        'priority': #(response.data.attributes.priority),
        'productAccountType': #(response.data.attributes.productAccountType.code),
        'productType': #(response.data.attributes.productType.code),
        'visualized': #(response.data.attributes.visualized)
      }
    """
    * setStepVariable('productAttributes', productAttributes)
