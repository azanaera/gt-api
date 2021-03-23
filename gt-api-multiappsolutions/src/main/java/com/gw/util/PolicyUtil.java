package com.gw.util;

import org.joda.time.format.DateTimeFormatter;
import org.joda.time.format.ISODateTimeFormat;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.ZoneOffset;
import java.time.ZonedDateTime;
import java.util.*;

public class PolicyUtil {
    private static final DateTimeFormatter dtf = ISODateTimeFormat.date();
    private static final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

    public static String getRandomName(String prefix){
        Random rand = new Random();
        return  prefix + (rand.nextInt( Integer.MAX_VALUE ) + 1);
    }

    public static String addMonthsToISODateString(String dateStr, int numMonths) throws ParseException {
        Date date = dtf.parseDateTime(dateStr).toDate();
        Calendar cal = Calendar.getInstance();
        cal.setTime(date);
        cal.add(Calendar.MONTH, numMonths);
        return sdf.format(cal.getTime());
    }

    public static String currentISODateString() throws ParseException {
        Date date = new Date();
        Calendar cal = Calendar.getInstance();
        cal.setTime(date);
        return sdf.format(cal.getTime());
    }

    public static Map<String, String> getDefaultCredentials() {
        Map<String, String> defaultCredentials = new HashMap<>();
        defaultCredentials.put("username", "su");
        defaultCredentials.put("password", "gw");
        return defaultCredentials;
    }

    public static String getDateWithDayOffset(long dayOffset, boolean isDateTimeFormat) {
        String adjustedDate = ZonedDateTime.now(ZoneOffset.UTC).plusDays(dayOffset).toString();
        return isDateTimeFormat ? (adjustedDate.substring(0,19) + "Z") : adjustedDate.substring(0,10);
    }
}
