# Introduction

The gt-api-claimsolutions module contains "End to End" ClaimCenter API test scenarios written using GT-API which is built on top of Karate. 

Karate is a framework for API testing that Guidewire adopted for testing REST APIs and the underlying functionality that they expose.

The documentation on Karate can be found on the main Karate website: https://intuit.github.io/karate/

These tests are intended for standalone ClaimCenter application.
The tests use TestSupport APIs to create Admin Data and Policy Transaction Data.

**Running tests in gt-api-claimsolutions module**
 
**Environment Set up**

Requirements
1.	CC standalone server with TestSupport APIs enabled
2.	ClaimServicingApis enabled 
 
**Running the tests**
1. CI/CD pipeline is required to run the tests continuously
2. IDE is required to run the tests locally
# karate-config.js

The gt-api-claimsolutions karate-config.js file defines the execution’s configuration for the gt-api-claimsolutions scenarios.

### Using A System Environment Variable

Set the "ccBaseUrl" system environment variable to the desired value.

### Modifying the “karate-config.js" File

Change undefined with the desired string value in the statement above.

```
var ccBaseUrl = java.lang.System.getenv('ccBaseUrl') ? java.lang.System.getenv('ccBaseUrl') : undefined;
```

e.g.,

In the statement below, the base url is google's.
```
var ccBaseUrl = java.lang.System.getenv('ccBaseUrl') ? java.lang.System.getenv('ccBaseUrl') : ‘https://www.google.com/’;
```
# Adding More Configuration Parameters to the "karate-config.js" File

"karate-config.js" defines the execution configuration for the scenarios in gt-api-claimsolutions.

New parameters can be added to this file to answer other needs and other requirements.
