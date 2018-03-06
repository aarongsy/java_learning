package com.eweaver.app.hrmanage;

import com.eweaver.base.BaseContext;
import com.eweaver.base.BaseJdbcDao;
import com.eweaver.base.util.StringHelper;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;

public class Vacation
{
  private String hours;

  public Vacation(String thebegindate, String thebegintime, String theenddate, String theendtime, String thetype, String reqman)
  {
    setHours(thebegindate, thebegintime, theenddate, theendtime, thetype, reqman);
  }

  public String getHours() {
    return this.hours;
  }
  public void setHours(String thebegindate, String thebegintime, String theenddate, String theendtime, String thetype, String reqman) {
    try {
      this.hours = getTotalHours(thebegindate, thebegintime, theenddate, theendtime, thetype, reqman);
    } catch (ParseException e) {
      this.hours = "0";
      e.printStackTrace();
    }
  }

  public String getTotalHours(String beginDate, String beginTime, String endDate, String endTime, String theType, String reqman) throws ParseException {
    double hours = 0.0D;
    boolean flag = true;
    BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
    Date theBegin = ft.parse(beginDate);
    Date theEnd = ft.parse(endDate);
    int nums = (int)((theEnd.getTime() - theBegin.getTime()) / 1000L / 60L / 60L / 24L);
    Calendar cdr = Calendar.getInstance();
    String pstime = "";
    String petime = "";
    String rstime = "";
    String retime = "";
    String classno = "";
    ArrayList dateList = new ArrayList();
    for (int i = 0; i < nums + 1; i++) {
      cdr.setTime(theBegin);
      cdr.add(5, i);
      String today = ft.format(cdr.getTime());
      String sql = "select a.classno,a.pstime,a.petime,a.rstime,a.retime from uf_hr_classinfo a,uf_hr_classplan b where a.requestid=b.classno and b.objname='" + reqman + "' and b.thedate='" + today + "'";
      List ls = baseJdbcDao.executeSqlForList(sql);
      if (ls.size() > 0) {
        Map m = (Map)ls.get(0);
        pstime = StringHelper.null2String(m.get("pstime"));
        petime = StringHelper.null2String(m.get("petime"));
        rstime = StringHelper.null2String(m.get("rstime"));
        retime = StringHelper.null2String(m.get("retime"));
        classno = StringHelper.null2String(m.get("classno"));
        SimpleDateFormat sft = new SimpleDateFormat("HH:mm:ss");
        Date ps = sft.parse(pstime);
        Date pe = sft.parse(petime);
        if (ps.getTime() >= pe.getTime()) {
          cdr.setTime(theBegin);
          cdr.add(5, i + 1);
          String nextDay = ft.format(cdr.getTime());
          pstime = today + " " + pstime;
          petime = nextDay + " " + petime;
        } else {
          pstime = today + " " + pstime;
          petime = today + " " + petime;
        }
        if (!rstime.equals("")) {
          Date rs = sft.parse(rstime);
          Date re = sft.parse(retime);
          if (rs.getTime() < ps.getTime()) {
            cdr.setTime(theBegin);
            cdr.add(5, i + 1);
            String nextDay = ft.format(cdr.getTime());
            rstime = nextDay + " " + rstime;
            retime = nextDay + " " + retime;
          } else if (rs.getTime() >= re.getTime()) {
            cdr.setTime(theBegin);
            cdr.add(5, i + 1);
            String nextDay = ft.format(cdr.getTime());
            rstime = today + " " + rstime;
            retime = nextDay + " " + retime;
          } else {
            rstime = today + " " + rstime;
            retime = today + " " + retime;
          }
        }
        if ((theType.equals("40285a904931f62b014936582eae18d3")) || ((!theType.equals("40285a904931f62b014936582eae18d3")) && (!classno.equals("OFF")))) {
          dateList.add(pstime);
          if (!rstime.equals("")) {
            dateList.add(rstime);
            dateList.add(retime);
          }
          dateList.add(petime);
        }
      } else {
        flag = false;
        break;
      }
    }
    if (flag) {
      String beginDateTime = beginDate + " " + beginTime;
      String endDateTime = endDate + " " + endTime;
      SimpleDateFormat sdt = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
      Date sp = sdt.parse(beginDateTime);
      Date ep = sdt.parse(endDateTime);
      Date listBegin = sdt.parse((String)dateList.get(0));
      Date listEnd = sdt.parse((String)dateList.get(dateList.size() - 1));
      if (sp.getTime() >= ep.getTime()) {
        hours = 0.0D;
      }
      else if (ep.getTime() <= listBegin.getTime()) {
        hours = 0.0D;
      } else if (sp.getTime() >= listEnd.getTime()) {
        hours = 0.0D;
      } else {
        int begin = 0;
        int end = 0;
        for (int i = 0; i < dateList.size(); i++) {
          Date listDate = sdt.parse((String)dateList.get(i));
          if (sp.getTime() >= listDate.getTime())
            begin = i;
          else begin = -1;
          if (ep.getTime() >= listDate.getTime()) {
            end = i;
          }
        }
        if (begin != -1) {
          if (begin % 2 == 0) {
            dateList.set(begin, beginDateTime);
          }
          else {
            for (int m = 0; m < begin; m++) {
              dateList.remove(m);
            }
          }
        }
        if (end % 2 == 0)
          dateList.set(end + 1, endDateTime);
        else {
          for (int m = end + 1; m < dateList.size(); m++) {
            dateList.remove(m);
          }
        }

        for (int n = 1; n < dateList.size(); n += 2) {
          Date s = sdt.parse((String)dateList.get(n - 1));
          Date e = sdt.parse((String)dateList.get(n));
          hours += (e.getTime() - s.getTime()) / 1000.0D / 60.0D / 60.0D;
        }
      }
    }
    else
    {
      hours = 0.0D;
    }
    return String.format("%.2f", new Object[] { Double.valueOf(hours) });
  }
}