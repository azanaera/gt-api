function fn() {

    var ccBaseUrl = java.lang.System.getenv('ccBaseUrl') ? java.lang.System.getenv('ccBaseUrl') : 'http://localhost:8080/cc';

    var config = {
        util: Java.type('com.gw.util.KarateJavaUtil'),
        testUtils: Java.type('com.gw.util.Utilities'),
        testDataContainer: Java.type('com.gw.cucumber.testData.TestDataContainer'),

        assertEqual : function(actual, expected){
            var result = karate.match(actual, expected);
            if(!result.pass){
                throw "assertEqual: Actual value '" + actual + "' did not match expected value '" + expected + "'."
            }
        }
    };

    config.ccBaseUrl = ccBaseUrl ? ccBaseUrl : '';

    karate.configure('logPrettyRequest', true);
    karate.configure('logPrettyResponse', true);
    // preparing the JSON to pass as a parameter for app health check feature in gt-api-framework
    // JSON contains the config and the appUrl
    var configAppUrl = { config: config, appUrl: config.ccBaseUrl };
    karate.callSingle('classpath:com/gw/util/CheckServerUp.feature@id=AppHealthCheck', configAppUrl);
    return config;
}