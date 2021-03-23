import io.cucumber.junit.Cucumber;
import io.cucumber.junit.CucumberOptions;
import org.junit.runner.RunWith;

@RunWith(Cucumber.class)
@CucumberOptions(
        features = {"src/main/java/com/gw/cucumber/"},
        glue = {"com.gw.cucumber"},
        strict = true,
        plugin = { "progress", "html:target/cucumber-reports",
                   "json:target/cucumber-reports/Cucumber.json",
                   "junit:target/cucumber-reports/Cucumber.xml" },
        tags = {"@CucumberSample"}
)
public class SampleCucumberScenariosRunner {
}
