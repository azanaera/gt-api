# Introduction

The gt-api-policysolutions module contains "End to End" PolicyCenter API test scenarios written using GT-API which is built on top of Karate. 

Karate is a framework for API testing that Guidewire adopted for testing REST APIs and the underlying functionality that they expose.

The documentation on Karate can be found on the main Karate website: https://intuit.github.io/karate/

These tests are intended for standalone PolicyCenter application.
The tests use TestSupport apis  to create Admin Data  and Policy Transaction Data.

**Running tests in gt-api-policysolutions module**
 
**Environment Set up**

Requirements
1.  PC standalone server with TestSupport APIs enabled
2.  Product Definition APIs enabled
3.  LOB APIs enabled
4.  Small sample data loaded
 
**Running the tests**
1. CI/CD pipeline is required to run the tests continuously
2. IDE is required to run the tests locally
# karate-config.js

The gt-api-policysolutions karate-config.js file defines the execution’s configuration for the gt-api-policysolutions scenarios.

### Using A System Environment Variable

Set the "pcBaseUrl" system environment variable to the desired value.

### Modifying the “karate-config.js" File

Change undefined with the desired string value in the statement above.

```
var pcBaseUrl = java.lang.System.getenv('pcBaseUrl') ? java.lang.System.getenv('pcBaseUrl') : undefined;
```

e.g.,

In the statement below, the base url is google's.
```
var pcBaseUrl = java.lang.System.getenv('pcBaseUrl') ? java.lang.System.getenv('pcBaseUrl') : ‘https://www.google.com/’;
```
# Adding More Configuration Parameters to the "karate-config.js" File

"karate-config.js" defines the execution configuration for the scenarios in gt-api-policysolutions.

New parameters can be added to this file to answer other needs and other requirements.
