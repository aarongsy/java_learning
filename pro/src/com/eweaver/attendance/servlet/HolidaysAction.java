package com.eweaver.attendance.servlet;

import com.eweaver.attendance.dao.HolidaysInfoDao;
import com.eweaver.attendance.model.HolidaysInfo;
import com.eweaver.attendance.service.HolidaysService;
import com.eweaver.base.AbstractBaseAction;
import com.eweaver.base.util.DateHelper;
import com.eweaver.base.util.StringHelper;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

public class HolidaysAction extends AbstractBaseAction
{
  private HolidaysService holidaysService = null;

  public HolidaysAction(HttpServletRequest paramHttpServletRequest, HttpServletResponse paramHttpServletResponse)
  {
    super(paramHttpServletRequest, paramHttpServletResponse);
  }

  public void execute()
    throws IOException, ServletException
  {
    String str1 = getParameter("month");
    if (str1.equalsIgnoreCase(""))
      str1 = DateHelper.getCurrentMonth();
    String str2 = getParameter("action");
    HashMap localHashMap = new HashMap();
    PrintWriter localPrintWriter = this.response.getWriter();
    String str3 = getParameter("day");
    if (str1.equalsIgnoreCase(""))
      str1 = DateHelper.getCurrentMonth();
    Object localObject1;
    if ((str2.equalsIgnoreCase("update")) && (!StringHelper.isEmpty(str3)))
    {
      localObject1 = this.holidaysService.getHolidaysInfoByDay(str3);
      if (localObject1 == null)
      {
        localObject1 = new HolidaysInfo();
        ((HolidaysInfo)localObject1).setDate1(str3);
      }
      String str4 = getParameter("weekend");
      ((HolidaysInfo)localObject1).setDaytype(Integer.valueOf(str4.equalsIgnoreCase("true") ? 2 : 1));
      ((HolidaysInfo)localObject1).setIsHoliday(Integer.valueOf(getParameter("holiday").equalsIgnoreCase("true") ? 1 : 0));
      ((HolidaysInfo)localObject1).setIsWorkday(Integer.valueOf(getParameter("workday").equalsIgnoreCase("true") ? 1 : 0));
      this.holidaysService.getHolidaysInfoDao().save(localObject1);
      localPrintWriter.print("ok,day:" + str3);
      return;
    }
    if (!str2.equalsIgnoreCase("save"))
    {
      Object localObject2;
      if (str2.equalsIgnoreCase("json"))
      {
        localObject1 = new JSONArray();
        for (int i = 0; i < 3; i++)
        {
          JSONObject localJSONObject1 = new JSONObject();
          localJSONObject1.put("id", i + "");
          localJSONObject1.put("name", "name" + i);
          ((JSONArray)localObject1).add(localJSONObject1);
        }
        localObject2 = new JSONObject();
        ((JSONObject)localObject2).put("result", localObject1);
        localPrintWriter.print(localObject2);
      }
      else
      {
        localObject1 = Calendar.getInstance();
        localObject2 = new SimpleDateFormat("yyyy-MM");
        try
        {
          ((Calendar)localObject1).setTime(((SimpleDateFormat)localObject2).parse(str1));
        }
        catch (ParseException localParseException)
        {
          localParseException.printStackTrace();
        }
        Date localDate = ((Calendar)localObject1).getTime();
        int j = ((Calendar)localObject1).get(7);
        int k = ((Calendar)localObject1).getActualMaximum(5);
        localHashMap.put("days", Integer.valueOf(k));
        localHashMap.put("nWeek", Integer.valueOf(j));
        localHashMap.put("weekPos1", DateHelper.getFirstDayOfMonthWeek(localDate));
        localHashMap.put("weekPos2", DateHelper.getLastDayOfMonthWeek(localDate));
        localHashMap.put("month", str1);
        List localList = this.holidaysService.getListByMonth(str1);
        JSONObject localJSONObject2 = new JSONObject();
        Iterator localIterator = localList.iterator();
        while (localIterator.hasNext())
        {
          HolidaysInfo localHolidaysInfo = (HolidaysInfo)localIterator.next();
          JSONObject localJSONObject3 = new JSONObject();
          localJSONObject3.put("isHoliday", Boolean.valueOf(localHolidaysInfo.getIsHoliday().intValue() == 1));
          localJSONObject3.put("isWorkday", Boolean.valueOf(localHolidaysInfo.getIsWorkday().intValue() == 1));
          localJSONObject2.put(localHolidaysInfo.getDate1(), localJSONObject3);
        }
        localHashMap.put("holidays", localJSONObject2.toString());
        ToView("/attendance/holidaysList.jsp", localHashMap);
      }
    }
  }
}