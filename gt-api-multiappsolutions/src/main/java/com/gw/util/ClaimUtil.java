package com.gw.util;

import java.time.ZoneOffset;
import java.time.ZonedDateTime;

public class ClaimUtil {
    // generate user names like adjuster12876
    public static String getTestDataUserName(String testUserName){
        return testUserName + (int)Math.floor((Math.random() * 100000) + 1);
    }


    /* Get UTC/ISO-8601 Date/Time or Date only

        1) main method getDateWithDayOffset, arguments: long days, boolean isDateTimeFormat:
           days: the future f.e. +5; in the past f.e. -3; last month: -31
           isDateTimeFormat: true or false.
           true – DateTime format - UTC/ISO-8601 date-time format like "2020-04-24T22:06:32.000Z"
           false – Date only format - yyyy-mm-dd f.e. "2020-04-24"

        2) Two generic methods without parameters that use the main one:
             - getCurrentDateTime()    gives today Date/Time ISO-8601 format like "2020-04-24T22:06:32.000Z"
             - getCurrentDate()        gives today Date only format like "2020-04-24"
    */
    public static String getDateWithDayOffset(long dayOffset, boolean isDateTimeFormat) {
        String adjustedDate = ZonedDateTime.now(ZoneOffset.UTC).plusDays(dayOffset).toString();
        return isDateTimeFormat ? (adjustedDate.substring(0,19) + "Z") : adjustedDate.substring(0,10);
    }
    public static String getCurrentDateTime() {
        return getDateWithDayOffset(0,true);
    }
    public static String getCurrentDate() {
        return getDateWithDayOffset(0,false);
    }
}
