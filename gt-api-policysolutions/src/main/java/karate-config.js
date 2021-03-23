function fn() {
    var pcBaseUrl = java.lang.System.getenv('pcBaseUrl') ? java.lang.System.getenv('pcBaseUrl') : 'http://localhost:8180/pc';

    var tdmUtil = Java.type('com.gw.datacreation.admindata.PolicyAdminDataResponseWriter');
    tdmUtil.setTDMLocation(java.lang.System.getenv('tdmPCDataFileLocation') ?
        java.lang.System.getenv('tdmPCDataFileLocation') : '/gt-api-policysolutions/src/main/java/');

    var config = {
        util: Java.type('com.gw.util.KarateJavaUtil'),
        policyUtil: Java.type('com.gw.util.PolicyUtil'),
        policyDataContainer : Java.type('com.gw.datacreation.admindata.PolicyDataContainer')
    };

    karate.configure('logPrettyRequest', true);
    karate.configure('logPrettyResponse', true);

    config.pcBaseUrl = pcBaseUrl ? pcBaseUrl : '';

    // preparing the JSON to pass as a parameter for app health check feature in gt-api-framework
    // JSON contains the config and the appUrl
    var configAppUrl = { config: config, appUrl: config.pcBaseUrl };

    if(!java.lang.System.getProperty('isLoadTest')){
        karate.callSingle('classpath:com/gw/util/CheckServerUp.feature@id=AppHealthCheck', configAppUrl);
    }
    return config;
}
