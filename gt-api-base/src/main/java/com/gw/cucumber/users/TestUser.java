package com.gw.cucumber.users;

public class TestUser {

    private String name;
    private String groupId;
    private String id;

    public TestUser(String name, String groupId, String id){
       this.name = name;
       this.groupId = groupId;
       this.id = id;
    }

    public String getName(){
        return this.name;
    }

    public String getGroupId(){
        return this.groupId;
    }

    public String getId(){
        return this.id;
    }

}
