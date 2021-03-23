# Introduction

The gt-api-multiappsolutions module contains "End to End" Integration Test Scenarios for  ClaimCenter API and PolicyCenter API  written using GT-API which is built on top of Karate. 

Karate is a framework for API testing that Guidewire adopted for testing REST APIs and the underlying functionality that they expose.

The documentation on Karate can be found on the main Karate website: https://intuit.github.io/karate/

These tests are intended for integrated ClaimCenter and PolicyCenter applications.
The tests use TestSupport apis to create Admin Data in both ClaimCenter and PolicyCenter  and use  PolicyCenter System APIs to create Policy Transaction Data.
 
**Environment Set up**

Requirements
1.	CC/PC integrated environment with TestSupport apis enabled
2.	PolicyCenter CommercialAuto LOB enabled
3.	ClaimServicingApis enabled 
 
**Running the tests**
1. CI/CD pipeline is required to run the tests continuously 
2. IDE is required to run the tests locally
# karate-config.js

The gt-api-multiappsolutions karate-config.js file defines the execution’s configuration for the integration scenarios.

```
var ccBaseUrl = java.lang.System.getenv('ccBaseUrl') ? java.lang.System.getenv('ccBaseUrl') : undefined;
```

### Using A System Environment Variable

Set the "ccBaseUrl" and "pcBaseUrl" system environment variable to the desired value.

### Modifying the “karate-config.js" File

Change undefined with the desired string value in the statement above.

```
var ccBaseUrl = java.lang.System.getenv('multiAppCCBaseUrl') ? java.lang.System.getenv('multiAppCCBaseUrl') : undefined;
var pcBaseUrl = java.lang.System.getenv('multiAppPCBaseUrl') ? java.lang.System.getenv('multiAppPCBaseUrl') : undefined;
```

e.g.,

In the example below, the base url is google's.
```
var ccBaseUrl = java.lang.System.getenv('multiAppCCBaseUrl') ? java.lang.System.getenv('multiAppCCBaseUrl') : ‘https://www.google.com/’;
```
# Adding More Configuration Parameters to the "karate-config.js" File

"karate-config.js" defines the execution configuration for the scenarios in gt-api-multiappsolutions.

New parameters can be added to this file to answer other needs and other requirements.
