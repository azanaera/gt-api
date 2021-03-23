function fn() {
    var Base64 = Java.type('java.util.Base64');
    var userPass = karate.get('username') + ':' + karate.get('password');
    var encoded = Base64.getEncoder().encodeToString(userPass.bytes);
    var headers = {}
    headers['Authorization'] = 'Basic ' + encoded;
    return karate.merge(headers, traceHeadersUtil.generateTraceHeaders());
}