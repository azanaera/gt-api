Feature: Search claims based on policy and reporter search criteria
  As an adjuster I want to search claims based on given policy number and reporter

  Background:
    Given step('CreateClaimAdminData.CCAdminData')
    * def sharedPath = 'classpath:com/gw/apitests/CommercialAuto/SearchClaimAndActivitiesWithDifferentSearchCriteria/'

  @id=FindClaims
  Scenario: Find Claims meeting criteria set by input parameters: Either policy number match or policy number and reporter first and last name matches
    * def requiredScenarioArguments = ['expectedClaims', 'policyNumber', 'maxPageOffset']
    * def optionalScenarioArguments = ['reporterFirstName','reporterLastName']
    * def templateFile = (typeof __arg.scenarioArgs.reporterFirstName !== 'undefined') ? (sharedPath + 'searchClaimsForPolicyAndReporter.json') : (sharedPath + 'searchClaimsForPolicy.json')
    * def findClaims =
      """
         function() {
         try {
              var pageOffSet = 0;
              var maxPageOffset = __arg.scenarioArgs.maxPageOffset;
              var matchedClaimsCount = 0;
              var expectedMatchedClaimsCount = __arg.scenarioArgs.expectedClaims.length;
              do {
                   step('SearchClaimsBasedOnPolicyAndReporter.FindClaimsOnPage',{'scenarioArgs':{'pageOffset': pageOffSet, 'templateFile': templateFile},'templateArgs': __arg.scenarioArgs});
                   var actualClaims = karate.jsonPath(getStepResponse('SearchClaimsBasedOnPolicyAndReporter.FindClaimsOnPage'), '$.data[*].attributes.claimId');
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
