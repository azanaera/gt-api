package com.gw.apicomponents.producercodes;

public class ProducerCodeDO {

    private String code;
    private String id;
    private String organization;

    public ProducerCodeDO(String code, String id, String organization){
       this.code = code;
       this.id = id;
       this.organization = organization;
    }

    public String getCode(){
        return this.code;
    }

    public String getId(){
        return this.id;
    }

    public String getOrganization() {
        return this.organization;
    }

}
