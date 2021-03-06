package com.gw.datacreation.admindata;

import com.gw.apicomponents.groups.GroupDO;
import com.gw.apicomponents.producercodes.ProducerCodeDO;
import com.gw.apicomponents.users.PolicyUserDO;
import com.gw.util.KarateJavaWrapper;

import java.util.HashMap;
import java.util.Map;

public class PolicyDataContainer {

    private static Map<String, PolicyUserDO> users = new HashMap<>();

    public static PolicyUserDO getPolicyUser(String userObjectName){
        if(users.containsKey(userObjectName)){
            return users.get(userObjectName);
        }else {
            throw new KarateJavaWrapper.WrappedJavaException(new RuntimeException("Unable to find user with object identifier : " + userObjectName));
        }
    }

    public static void setPolicyUser(String userObjectName, PolicyUserDO userDO){
        users.put(userObjectName, userDO);
    }

    private static Map<String, GroupDO> groups = new HashMap<>();

    public static GroupDO getPolicyGroup(String userObjectName){
        if(groups.containsKey(userObjectName)){
            return groups.get(userObjectName);
        }else {
            throw new KarateJavaWrapper.WrappedJavaException(new RuntimeException("Unable to find user with object identifier : " + userObjectName));
        }
    }

    public static void setPolicyGroup(String userObjectName, GroupDO groupDO){
        groups.put(userObjectName, groupDO);
    }

    private static Map<String, ProducerCodeDO> producerCodes = new HashMap<>();

    public static ProducerCodeDO getPolicyProducerCode(String userObjectName){
        if(producerCodes.containsKey(userObjectName)){
            return producerCodes.get(userObjectName);
        }else {
            throw new KarateJavaWrapper.WrappedJavaException(new RuntimeException("Unable to find user with object identifier : " + userObjectName));
        }
    }

    public static void setPolicyProducerCode(String userObjectName, ProducerCodeDO producerCodeDO){
        producerCodes.put(userObjectName, producerCodeDO);
    }

    public static boolean isDataLoaded() {
        return !(producerCodes.isEmpty() || groups.isEmpty() || users.isEmpty());
    }

}