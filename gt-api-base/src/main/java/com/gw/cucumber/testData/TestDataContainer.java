package com.gw.cucumber.testData;

import com.gw.cucumber.users.TestUser;
import com.gw.util.KarateJavaWrapper;

import java.util.HashMap;
import java.util.Map;

public class TestDataContainer {

    private static Map<String, TestUser> testUsers = new HashMap<>();

    public static TestUser getUser(String userObjectName){
       if(testUsers.containsKey(userObjectName)){
           return testUsers.get(userObjectName);
       }else {
           throw new KarateJavaWrapper.WrappedJavaException(new RuntimeException("Unable to find user with object identifier : " + userObjectName));
       }
    }

    public static void setUser(String userObjectName, TestUser user){
        testUsers.put(userObjectName, user);
    }

    public static boolean isDataLoaded() {
        return !(testUsers.isEmpty());
    }

}
