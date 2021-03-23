function fn() {
    var ccBaseUrl = java.lang.System.getenv('ccBaseUrl') ? java.lang.System.getenv('ccBaseUrl') : 'http://localhost:8080/cc';

    var tdmUtil = Java.type('com.gw.datacreation.admindata.ClaimsAdminDataResponseWriter');
    tdmUtil.setTDMLocation(java.lang.System.getenv('tdmCCDataFileLocation') ?
        java.lang.System.getenv('tdmCCDataFileLocation') : '/gt-api-claimsolutions/src/main/java/');

    var config = {
        util: Java.type('com.gw.util.KarateJavaUtil'),
        claimUtils: Java.type('com.gw.util.ClaimUtil'),
        claimsDataContainer : Java.type('com.gw.datacreation.admindata.ClaimsDataContainer'),

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

    karate.configure('logPrettyRequest', true);
    karate.configure('logPrettyResponse', true);

    // preparing the JSON to pass as a parameter for app health check feature in gt-api-framework
    // JSON contains the config and the appUrl
    var configAppUrl = { config: config, appUrl: config.ccBaseUrl };

    if(!java.lang.System.getProperty('isLoadTest')){
        karate.callSingle('classpath:com/gw/util/CheckServerUp.feature@id=AppHealthCheck', configAppUrl);
    }

    return config;
}
