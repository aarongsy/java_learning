package com.eweaver.app;

import com.eweaver.base.DataService;
import java.io.PrintStream;
import java.text.ParsePosition;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

public class DHelper
{
  public static boolean isLeapYear(String paramString)
  {
    Date localDate = strToDate(paramString);
    GregorianCalendar localGregorianCalendar = (GregorianCalendar)Calendar.getInstance();
    localGregorianCalendar.setTime(localDate);
    int i = localGregorianCalendar.get(1);
    if (i % 400 == 0)
      return true;
    if (i % 4 == 0)
      return i % 100 != 0;
    return false;
  }

  public static String getNextDay(String paramString1, String paramString2)
  {
    try
    {
      SimpleDateFormat localSimpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
      String str = "";
      Date localDate = strToDate(paramString1);
      long l = localDate.getTime() / 1000L + Integer.parseInt(paramString2) * 24 * 60 * 60;
      localDate.setTime(l * 1000L);
      str = localSimpleDateFormat.format(localDate);
      return str;
    }
    catch (Exception localException)
    {
    }
    return "";
  }

  public static Date strToDate(String paramString)
  {
    SimpleDateFormat localSimpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
    ParsePosition localParsePosition = new ParsePosition(0);
    Date localDate = localSimpleDateFormat.parse(paramString, localParsePosition);
    return localDate;
  }

  public static String getEndDateOfMonth(String paramString)
  {
    String str1 = paramString.substring(0, 8);
    String str2 = paramString.substring(5, 7);
    int i = Integer.parseInt(str2);
    if ((i == 1) || (i == 3) || (i == 5) || (i == 7) || (i == 8) || (i == 10) || (i == 12))
      str1 = str1 + "31";
    else if ((i == 4) || (i == 6) || (i == 9) || (i == 11))
      str1 = str1 + "30";
    else if (isLeapYear(paramString))
      str1 = str1 + "29";
    else
      str1 = str1 + "28";
    return str1;
  }

  public static String getWeek(String paramString)
  {
    Date localDate = strToDate(paramString);
    Calendar localCalendar = Calendar.getInstance();
    localCalendar.setTime(localDate);
    return new SimpleDateFormat("EEEE").format(localCalendar.getTime());
  }

  public static String getWeekStr(String paramString)
  {
    String str = "";
    str = getWeek(paramString);
    if ("1".equals(str))
      str = "星期日";
    else if ("2".equals(str))
      str = "星期一";
    else if ("3".equals(str))
      str = "星期二";
    else if ("4".equals(str))
      str = "星期三";
    else if ("5".equals(str))
      str = "星期四";
    else if ("6".equals(str))
      str = "星期五";
    else if ("7".equals(str))
      str = "星期六";
    return str;
  }

  public static String getNowMonth(String paramString)
  {
    paramString = paramString + "-01";
    Calendar localCalendar = Calendar.getInstance();
    Date localDate = strToDate(paramString);
    localCalendar.setTime(localDate);
    int i = localCalendar.get(7);
    String str = getNextDay(paramString, 1 - i + "");
    return str;
  }

  public static String getMonthDate(String paramString)
  {
    DataService localDataService = new DataService();
    String str1 = "delete from zview";
    localDataService.executeSql(str1);
    paramString = paramString + "-01";
    Calendar localCalendar = Calendar.getInstance();
    Date localDate = strToDate(paramString);
    localCalendar.setTime(localDate);
    int i = localCalendar.get(7);
    String str2 = getEndDateOfMonth(paramString);
    String str3 = getNextDay(paramString, 1 - i + "");
    int j = 0;
    int k = 1;
    System.out.println();
    do
    {
      str3 = getNextDay(paramString, "" + j++);
      String str4 = getWeek(str3);
      if ((!str4.equals("星期日")) && (!str4.equals("星期六")))
      {
        String str5 = "insert into zview(zint,zdate,zweek) values(" + k + ",'" + str3 + "','" + str4 + "')";
        localDataService.executeSql(str5);
        System.out.println("第" + k + "周");
        System.out.print(str3);
        System.out.print(str4);
      }
      if (str4.equals("星期六"))
        k++;
    }
    while (!str3.equals(str2));
    return str3;
  }
}