package com.gw;

import com.intuit.karate.core.Action;
import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.When;

import java.util.List;
import java.util.Map;

public class KarateStepActions {

    @When("^configure ([^\\s]+) =$")
    public void configureDocstring(String key, String exp) {
    }


    @When("^configure ([^\\s]+) = (.+)")
    public void configure(String key, String exp) {
    }


    @When("^url (.+)")
    public void url(String expression) {
    }


    @When("^path (.+)")
    public void path(List<String> paths) {
    }


    @When("^param ([^\\s]+) = (.+)")
    public void param(String name, List<String> values) {
    }


    @When("^params (.+)")
    public void params(String expr) {
    }


    @When("^cookie ([^\\s]+) = (.+)")
    public void cookie(String name, String value) {
    }


    @When("^cookies (.+)")
    public void cookies(String expr) {
    }


    @When("^csv (.+) = (.+)")
    public void csv(String name, String expression) {
    }


    @When("^header ([^\\s]+) = (.+)")
    public void header(String name, List<String> values) {
    }


    @When("^headers (.+)")
    public void headers(String expr) {
    }


    @When("^form field ([^\\s]+) = (.+)")
    public void formField(String name, List<String> values) {
    }


    @When("^form fields (.+)")
    public void formFields(String expr) {
    }


    @When("^request$")
    public void requestDocstring(String body) {
    }


    @When("^request (.+)")
    public void request(String body) {
    }

    @When("^table (.+)")
    public void table(String name, DataTable table) {
    }


    @Action("^table (.+)")
    public void table(String name, List<Map<String, String>> table) {
    }

    @When("^replace (\\w+)$")
    public void replace(String name, DataTable table) {
    }


    @Action("^replace (\\w+)$")
    public void replace(String name, List<Map<String, String>> table) {
    }


    @When("^replace (\\w+).([^\\s]+) = (.+)")
    public void replace(String name, String token, String value) {
    }


    @When("^def (.+) =$")
    public void defDocstring(String name, String expression) {
    }


    @When("^def (\\w+) = (.+)")
    public void def(String name, String expression) {
    }


    @When("^text (.+) =$")
    public void text(String name, String expression) {
    }


    @When("^yaml (.+) = (.+)")
    public void yaml(String name, String expression) {
    }


    @When("^copy (.+) = (.+)")
    public void copy(String name, String expression) {
    }


    @When("^json (.+) = (.+)")
    public void json(String name, String expression) {
    }


    @When("^string (.+) = (.+)")
    public void string(String name, String expression) {
    }


    @When("^xml (.+) = (.+)")
    public void xml(String name, String expression) {
    }


    @When("^xmlstring (.+) = (.+)")
    public void xmlstring(String name, String expression) {
    }


    @When("^bytes (.+) = (.+)")
    public void bytes(String name, String expression) {
    }


    @When("^assert (.+)")
    public void assertTrue(String expression) {
    }


    @When("^method (\\w+)")
    public void method(String method) {
    }


    @When("^retry until (.+)")
    public void retry(String until) {
    }


    @When("^soap action( .+)?")
    public void soapAction(String action) {
    }


    @When("^multipart entity (.+)")
    public void multipartEntity(String value) {
    }


    @When("^multipart field (.+) = (.+)")
    public void multipartField(String name, String value) {
    }


    @When("^multipart fields (.+)")
    public void multipartFields(String expr) {
    }


    @When("^multipart file (.+) = (.+)")
    public void multipartFile(String name, String value) {
    }


    @When("^multipart files (.+)")
    public void multipartFiles(String expr) {
    }


    @When("^print (.+)")
    public void print(List<String> exps) {
    }


    @When("^status (\\d+)")
    public void status(int status) {
    }


    @When("^match (.+)(=|contains|any|only)$")
    public void matchDocstring(String expression, String operators, String rhs) {

    }


    @When("^match (.+)(=|contains|any|only)( .+)$")
    public void match(String expression, String operators, String rhs) {

    }


    @When("^set ([^\\s]+)( .+)? =$")
    public void setDocstring(String name, String path, String value) {
    }


    @When("^set ([^\\s]+)( .+)? = (.+)")
    public void set(String name, String path, String value) {
    }

    @When("^set ([^\\s]+)( [^=]+)?$")
    public void set(String name, String path, DataTable table) {
    }


    @Action("^set ([^\\s]+)( [^=]+)?$")
    public void set(String name, String path, List<Map<String, String>> table) {
    }


    @When("^remove ([^\\s]+)( .+)?")
    public void remove(String name, String path) {
    }


    @When("^call ([^\\s]+)( .*)?")
    public void call(String name, String arg) {
    }


    @When("^callonce ([^\\s]+)( .*)?")
    public void callonce(String name, String arg) {
    }


    @When("^eval (.+)")
    public void eval(String exp) {
    }


    @When("^eval$")
    public void evalDocstring(String exp) {
    }


    @When("^([\\w]+)([^\\s^\\w])(.+)")
    public void eval(String name, String dotOrParen, String expression) {
    }


    @When("^if (.+)")
    public void evalIf(String exp) {
    }


}