function fn() {
    var ccBaseUrl = java.lang.System.getenv('multiAppCCBaseUrl') ? java.lang.System.getenv('multiAppCCBaseUrl') : 'http://localhost:8080/cc';
    var pcBaseUrl = java.lang.System.getenv('multiAppPCBaseUrl') ? java.lang.System.getenv('multiAppPCBaseUrl') : 'http://localhost:8180/pc';

    var config = {
        util: Java.type('com.gw.util.KarateJavaUtil'),
        claimUtils: Java.type('com.gw.util.ClaimUtil'),
        claimsDataContainer : Java.type('com.gw.datacreation.admindata.ClaimsDataContainer'),
        enableCCTestAPIs: true,

        policyUtil: Java.type('com.gw.util.PolicyUtil'),
        policyDataContainer : Java.type('com.gw.datacreation.admindata.PolicyDataContainer'),
        enablePCTestAPIs: true,

        assertEqual : function(actual, expected){
            var result = karate.match(actual, expected);
            if(!result.pass){
                throw "assertEqual: Actual value '" + actual + "' did not match expected value '" + expected + "'."
            }
        },

        getMatchedValueCount : function(srcJson, jsonToMatch){
            var matchedValueCount = 0;
            for (var key in jsonToMatch) {
                try{
                    var val = jsonToMatch[key];
                    for(var srcKey in srcJson){
                        if (val === srcJson[srcKey]) {
                            matchedValueCount = matchedValueCount + 1;
                        }
                    }
                }
                catch(e){
                    karate.log(e);
                }
            }
            return matchedValueCount;
        }
    };

    config.ccBaseUrl = ccBaseUrl ? ccBaseUrl : '';
    config.pcBaseUrl = pcBaseUrl ? pcBaseUrl : '';

    karate.configure('logPrettyRequest', true);
    karate.configure('logPrettyResponse', true);

    // preparing the JSON to pass as a parameter for app health check feature in gt-api-framework
    // JSON contains the config and the appUrl
    var configCCAppUrl = { config: config, appUrl: config.ccBaseUrl};
    var configPCAppUrl = { config: config, appUrl: config.pcBaseUrl};

    if(!java.lang.System.getProperty('isLoadTest')){
        karate.callSingle('classpath:com/gw/util/CheckServerUp.feature@id=AppHealthCheck', configCCAppUrl);
        karate.callSingle('classpath:com/gw/util/CheckServerUp.feature@id=AppHealthCheck', configPCAppUrl);
        if(config.enableCCTestAPIs && config.enablePCTestAPIs) {
            karate.callSingle('classpath:com/gw/datacreation/admindata/CreateClaimsUsers.feature@id=SetupUsers', config);
            karate.callSingle('classpath:com/gw/datacreation/admindata/ProducerCodeGroupAndUsers.feature@id=SetupProducerCodes', config);
            karate.callSingle('classpath:com/gw/datacreation/admindata/ProducerCodeGroupAndUsers.feature@id=SetupGroups', config);
            karate.callSingle('classpath:com/gw/datacreation/admindata/ProducerCodeGroupAndUsers.feature@id=SetupUsers', config);
        }
    }

    return config;
}
