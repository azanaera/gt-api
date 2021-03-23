package com.gw.apicomponents.pc.groups;

public class GroupDO {

    private String name;
    private String id;

    public GroupDO(String name, String id){
       this.name = name;
       this.id = id;
    }

    public String getName(){
        return this.name;
    }

    public String getId(){
        return this.id;
    }

}
