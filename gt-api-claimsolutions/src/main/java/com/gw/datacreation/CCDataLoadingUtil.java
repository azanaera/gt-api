package com.gw.datacreation;

import com.gw.datacreation.admindata.ClaimsAdminDataResponseWriter;
import com.intuit.karate.Runner;
import com.intuit.karate.core.Feature;
import com.intuit.karate.core.FeatureParser;
import io.cucumber.core.cli.Main;

import java.util.Map;

public class CCDataLoadingUtil {
    /** Execute GT API E2E scenario */
    public static Map<String,Object> executeGtApiScenario(String featureFilePath, String scenarioTagToExecute, Map<String,Object> args){
        Feature feature = FeatureParser.parse(featureFilePath);
        feature.setCallTag(scenarioTagToExecute);
        return Runner.runFeature(feature,args,true);
    }

    /** Execute GT API E2E feature */
    public static Map<String,Object> executeGtApiFeature(String featureFilePath, String location, Map<String,Object> args){
        if(location!= null) {
            ClaimsAdminDataResponseWriter.setLocation(location);
        }
        System.out.println("in executeGtApiFeature: featureFilepath:" + featureFilePath + " args" + args);
        return Runner.runFeature(featureFilePath,args,true);
    }

    /** Execute Cucumber E2E feature */
    public static void executeCucumberFeature(String featureFilePath) {
        main(new String[]{featureFilePath});
    }

    private static void main(String[] args) {
        Main.main(new String[]{
                "-g",
                "com.gw.dataCreation",
                args[0]}
        );
    }
}
