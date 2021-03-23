package com.gw.cucumber.testData;

import org.jose4j.json.internal.json_simple.JSONArray;
import org.jose4j.json.internal.json_simple.JSONObject;

import java.io.FileWriter;
import java.io.IOException;
import java.util.HashMap;

public class TestDataResponseWriter {
    private static FileWriter file;
    private static JSONArray users = new JSONArray();
    private static String dataFileName = "/testDataContainer.json";
    private static String path = String.format("%s/%s",
            System.getProperty("user.dir")+"/gt-api-base/src/main/java/",
            new TestDataResponseWriter().getClass().getPackage().getName().replace(".", "/"));

    public static void addUser(String UserIdentifier, String UserName, String GroupId, String UserID) {
        JSONObject user = new JSONObject();
        user.put("testDataIdentifier",UserIdentifier);
        user.put("userName", UserName);
        user.put("groupId", GroupId);
        user.put("userId", UserID);
        users.add(user);
    }

    public static void saveTestData(){
        JSONObject obj = new JSONObject();
        obj.put("testData",new JSONObject(new HashMap(){{
            put("users",users);
        }}));

        try {
            // Constructs a FileWriter given a file name
            file = new FileWriter(path + dataFileName);
            file.write(obj.toJSONString());
            file.flush();
            file.close();
        } catch (IOException e) {
            throw new RuntimeException("TestDataResponseWriter.saveTestData(): Failed to save test data " + e.getMessage());
        }
    }
}
