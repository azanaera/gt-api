package com.gw.datacreation.admindata;

import com.gw.apicomponents.users.ClaimsUserDO;
import com.gw.util.KarateJavaWrapper;

import java.util.HashMap;
import java.util.Map;

public class ClaimsDataContainer {

    private static Map<String, ClaimsUserDO> testUsers = new HashMap<>();

    public static ClaimsUserDO getClaimsUser(String userObjectName){
       if(testUsers.containsKey(userObjectName)){
           return testUsers.get(userObjectName);
       }else {
           throw new KarateJavaWrapper.WrappedJavaException(new RuntimeException("Unable to find user with object identifier : " + userObjectName));
       }
    }

    public static String getPassword(){return "gw";}
    public static void setClaimsUser(String userObjectName, ClaimsUserDO user){
        testUsers.put(userObjectName, user);
    }

    public static boolean isDataLoaded() {
        return !(testUsers.isEmpty());
    }
}
