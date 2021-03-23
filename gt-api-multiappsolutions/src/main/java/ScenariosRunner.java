import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import net.masterthought.cucumber.Configuration;
import net.masterthought.cucumber.ReportBuilder;
import org.apache.commons.io.FileUtils;
import org.junit.Assert;

import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;

public class ScenariosRunner {

    /*  Replace the call to executeScenariosByGroup() in the main method with a call to executeScenariosById()
     *  if you are executing scenarios based on their ids tags instead of group/suite tags
     *  e.g., executeScenariosById("ICreateActivityOnClosedClaim")
     *  Note:  Pass the id tag value without the tag's name (i.e., you do not need to pass 'id='. See example right above)
     */
    public static void main(String[] args) {
        //Assume we have single argument: the profile/karate environment argument
        if(args != null && args.length > 0){
            String profile = args[0].toLowerCase().trim();
            System.setProperty("karate.env", profile);
        }
        //Note : specify regression or smoke test tag as a separate item in array. ex:  "@DevTheme2QuoteAndBindDemoScenario,@DevTheme3QuoteWithRuleValidationError","Regression"
        List<String> tags = Arrays.asList("@RunAll");
        List<String> features = Arrays.asList("classpath:com/gw/");
        runScenarios(tags, features);
    }

    public static void runScenarios(List<String> scenariosTags, List<String> features){
        String karateOutputPath = "target/surefire-reports";
        Results results = Runner.parallel(scenariosTags, features, 1, karateOutputPath);
        generateReport(karateOutputPath);
        Assert.assertTrue(results.getErrorMessages(), results.getFailCount() == 0);
    }

    public static void generateReport(String karateOutputPath) {
        Collection<File> jsonFiles = FileUtils.listFiles(new File(karateOutputPath), new String[] {"json"}, true);
        List<String> jsonPaths = new ArrayList(jsonFiles.size());
        jsonFiles.forEach(file -> jsonPaths.add(file.getAbsolutePath()));
        Configuration config = new Configuration(new File("target"), "portfolio-api-testing");
        ReportBuilder reportBuilder = new ReportBuilder(jsonPaths, config);
        reportBuilder.generateReports();
    }

}