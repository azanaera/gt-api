package com.gw.datacreation.admindata;

import org.jose4j.json.internal.json_simple.JSONArray;
import org.jose4j.json.internal.json_simple.JSONObject;

import java.io.FileWriter;
import java.io.IOException;
import java.util.HashMap;

public class ClaimsAdminDataResponseWriter {
    private static FileWriter file;
    private static JSONArray users = new JSONArray();
    private static String dataFileName = "/claimsDataContainer.json";
    private static String externalLocation = "";
    private static String location = "";

    private static String getPath() {
        if(!externalLocation.equals("")) {
            return String.format("%s",
                    System.getProperty("user.dir") + "/" + externalLocation);
        }
        return String.format("%s/%s",
                System.getProperty("user.dir") + location ,
                new ClaimsAdminDataResponseWriter().getClass().getPackage().getName().replace(".", "/"));
    }

    public static void addUser(String UserIdentifier, String UserName, String GroupId, String UserID) {
        JSONObject user = new JSONObject();
        user.put("testDataIdentifier",UserIdentifier);
        user.put("userName", UserName);
        user.put("groupId", GroupId);
        user.put("userId", UserID);
        users.add(user);
    }

    /**
     * This method is used for setting location from external systems (i.e.non- gt-api systems)
     */
    public static void setLocation(String locationValue) {
        externalLocation = locationValue;
    }

    /**
     * This method is used for setting location from karate-config.js for gt-api internal use.
     */
    public static void setTDMLocation(String locationValue) {
        location = locationValue;
    }

    public static void saveAdminData() {
        JSONObject obj = new JSONObject();
        obj.put("adminData",new JSONObject(new HashMap(){{
            put("users",users);
        }}));

        try {
            // Constructs a FileWriter given a file name
            file = new FileWriter(getPath() + dataFileName);
            file.write(obj.toJSONString());
            file.flush();
            file.close();
        } catch (IOException e) {
            throw new RuntimeException("ClaimsAdminDataResponseWriter.saveTestData(): Failed to save test data " + e.getMessage());
        }
    }
}