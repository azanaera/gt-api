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

    /*
     * Note that karate.env can be set as a system property.
     */
    public static void main(String[] args) {
        // Note: specify regression or smoke test tag as a separate item in array.
        // ex: "@DevTheme2QuoteAndBindDemoScenario,@DevTheme3QuoteWithRuleValidationError","Regression"
        List<String> tags = Arrays.asList("@RunAll");
        List<String> features = Arrays.asList("classpath:com/gw/");
        runScenarios(tags, features);
    }

    public static void runScenarios(List<String> scenariosTags, List<String> features){
        String karateOutputPath = "target/surefire-reports";
        Results results = Runner.parallel(scenariosTags, features, 1, karateOutputPath);
        generateReport(karateOutputPath);
        Assert.assertEquals(results.getErrorMessages(), 0, results.getFailCount());
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
