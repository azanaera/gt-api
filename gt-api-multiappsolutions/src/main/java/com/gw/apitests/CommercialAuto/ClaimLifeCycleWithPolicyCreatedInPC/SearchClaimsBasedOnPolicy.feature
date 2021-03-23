Feature: Search claims based on policy
  As an adjuster I want to search claims based on given policy number
  Background:
    * def username = claimusername
    * def password = claimpassword
    * configure headers = read('classpath:headers.js')
    * def sharedPath = 'classpath:com/gw/apitests/CommercialAuto/ClaimLifeCycleWithPolicyCreatedInPC/'

  @id=FindClaims
  Scenario: Find Claims meeting criteria set by input parameters: Either policy number match or policy number and reporter first and last name matches
    * def requiredScenarioArguments = ['expectedClaims', 'policyNumber', 'maxPageOffset']
    * def optionalScenarioArguments = ['reporterFirstName','reporterLastName']
    * def templateFile = (typeof __arg.scenarioArgs.reporterFirstName !== 'undefined') ? (sharedPath + 'searchClaimsForPolicy.json') : (sharedPath + 'searchClaimsForPolicy.json')
    * def findClaims =
      """
         function() {
         try {
              var pageOffSet = 0;
              var maxPageOffset = __arg.scenarioArgs.maxPageOffset;
              var matchedClaimsCount = 0;
              var expectedMatchedClaimsCount = __arg.scenarioArgs.expectedClaims.length;
              do {
                   step('SearchClaimsBasedOnPolicy.FindClaimsOnPage',{'scenarioArgs':{'pageOffset': pageOffSet, 'templateFile': templateFile},'templateArgs': __arg.scenarioArgs});
                   var actualClaims = karate.jsonPath(getStepResponse('SearchClaimsBasedOnPolicy.FindClaimsOnPage'), '$.data[*].attributes.claimId');
                   matchedClaimsCount = matchedClaimsCount + getMatchedValueCount(actualClaims, __arg.scenarioArgs.expectedClaims);
                   pageOffSet = pageOffSet + 25;
                   if (pageOffSet > maxPageOffset) {
                      throw "Failed to find claims with max page offset = " + maxPageOffset;
                   }
              } while(matchedClaimsCount !== expectedMatchedClaimsCount);

            }
            catch(e){
               karate.log(e);
               throw e;
            }
            return matchedClaimsCount
         }
      """
    * match findClaims() == __arg.scenarioArgs.expectedClaims.length

  @id=FindClaimsOnPage
  Scenario: Get Claims
    * def requiredScenarioArguments = ['pageOffset', 'templateFile']
    * def claimsUrl = ccBaseUrl + '/rest/claim/v1/search/claims' + '?pageOffset=' + __arg.scenarioArgs.pageOffset
    Given url claimsUrl
    And request readWithArgs(__arg.scenarioArgs.templateFile, __arg.templateArgs)
    When method POST
    Then status 200
