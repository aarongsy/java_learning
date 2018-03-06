package com.eweaver.app.hrmanage;

import com.eweaver.base.BaseContext;
import com.eweaver.base.BaseJdbcDao;
import com.eweaver.base.util.StringHelper;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;

public class VacationBackup
{
  private String hours;

  public VacationBackup(String thebegindate, String thebegintime, String theenddate, String theendtime, String thetype, String reqman)
  {
    setHours(thebegindate, thebegintime, theenddate, theendtime, thetype, reqman);
  }

  public String getHours() {
    return this.hours;
  }
  public void setHours(String thebegindate, String thebegintime, String theenddate, String theendtime, String thetype, String reqman) {
    try {
      this.hours = Hours(thebegindate, thebegintime, theenddate, theendtime, thetype, reqman);
    } catch (ParseException e) {
      this.hours = "0";
      e.printStackTrace();
    }
  }

  public String Hours(String thebegindate, String thebegintime, String theenddate, String theendtime, String thetype, String reqman) throws ParseException {
    double hours = 0.0D;
    BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    if (thebegindate.equals(theenddate)) {
      String sql = "select a.classno,a.pstime,a.petime,a.rstime,a.retime from uf_hr_classinfo a,uf_hr_classplan b where a.requestid=b.classno and b.objname='" + reqman + "' and b.thedate='" + thebegindate + "'";
      List ls = baseJdbcDao.executeSqlForList(sql);
      if (ls.size() > 0) {
        Map m = (Map)ls.get(0);
        String pstime = StringHelper.null2String(m.get("pstime"));
        String petime = StringHelper.null2String(m.get("petime"));
        String rstime = StringHelper.null2String(m.get("rstime"));
        String retime = StringHelper.null2String(m.get("retime"));
        String classno = StringHelper.null2String(m.get("classno"));
        if ((thetype.equals("40285a904931f62b014936582eae18d3")) || ((!thetype.equals("40285a904931f62b014936582eae18d3")) && (!classno.equals("OFF")))) {
          if (rstime.equals(""))
            hours = todayBeginHaveNoRestHours(thebegintime, theendtime, pstime, petime);
          else
            hours = todayBeginHaveRestHours(thebegintime, theendtime, pstime, petime, rstime, retime);
        }
        else
          hours = 0.0D;
      }
      else {
        hours = 0.0D;
      }
    } else {
      SimpleDateFormat sft = new SimpleDateFormat("yyyy-MM-dd");
      Date thestart = sft.parse(thebegindate);
      Date theend = sft.parse(theenddate);
      int dnums = (int)((theend.getTime() - thestart.getTime()) / 1000L / 60L / 60L / 24L);
      if (thetype.equals("40285a904931f62b014936582eae18d3")) {
        Calendar cdr = Calendar.getInstance();
        for (int i = 0; i < dnums + 1; i++) {
          cdr.setTime(thestart);
          cdr.add(5, i);
          String nextDate = sft.format(cdr.getTime());
          String sql = "select a.requestid,a.pstime,a.petime,a.rstime,a.retime,a.whours from uf_hr_classinfo a,uf_hr_classplan b where a.requestid=b.classno and b.objname='" + reqman + "' and b.thedate='" + nextDate + "'";
          List ls = baseJdbcDao.executeSqlForList(sql);
          if (ls.size() > 0) {
            Map m = (Map)ls.get(0);
            String pstime = StringHelper.null2String(m.get("pstime"));
            String petime = StringHelper.null2String(m.get("petime"));
            String rstime = StringHelper.null2String(m.get("rstime"));
            String retime = StringHelper.null2String(m.get("retime"));
            String whours = StringHelper.null2String(m.get("whours"));
            if (whours.equals("")) {
              whours = "0";
            }
            if (i == 0) {
              if (rstime.equals(""))
                hours += beginHaveNoRestHours(thebegintime, pstime, petime);
              else
                hours += beginHaveRestHours(thebegintime, pstime, petime, rstime, retime);
            }
            else if (i == dnums) {
              if (rstime.equals(""))
                hours += endHaveNoRestHours(thebegintime, pstime, petime);
              else
                hours += endHaveRestHours(thebegintime, pstime, petime, rstime, retime);
            }
            else
              hours += Double.valueOf(whours).doubleValue();
          }
          else {
            hours = 0.0D;
            break;
          }
        }
      } else {
        Calendar cdr = Calendar.getInstance();
        for (int i = 0; i < dnums + 1; i++) {
          cdr.setTime(thestart);
          cdr.add(5, i);
          String nextDate = sft.format(cdr.getTime());
          String sql = "select a.classno,a.pstime,a.petime,a.rstime,a.retime,a.whours from uf_hr_classinfo a,uf_hr_classplan b where a.requestid=b.classno and b.objname='" + reqman + "' and b.thedate='" + nextDate + "'";
          List ls = baseJdbcDao.executeSqlForList(sql);
          if (ls.size() > 0) {
            Map m = (Map)ls.get(0);
            String pstime = StringHelper.null2String(m.get("pstime"));
            String petime = StringHelper.null2String(m.get("petime"));
            String rstime = StringHelper.null2String(m.get("rstime"));
            String retime = StringHelper.null2String(m.get("retime"));
            String whours = StringHelper.null2String(m.get("whours"));
            String classno = StringHelper.null2String(m.get("classno"));
            if (whours.equals("")) {
              whours = "0";
            }
            if (!classno.equals("OFF"))
              if (i == 0) {
                if (rstime.equals(""))
                  hours += beginHaveNoRestHours(thebegintime, pstime, petime);
                else
                  hours += beginHaveRestHours(thebegintime, pstime, petime, rstime, retime);
              }
              else if (i == dnums) {
                if (rstime.equals(""))
                  hours += endHaveNoRestHours(thebegintime, pstime, petime);
                else
                  hours += endHaveRestHours(thebegintime, pstime, petime, rstime, retime);
              }
              else
                hours += Double.valueOf(whours).doubleValue();
          }
          else
          {
            hours = 0.0D;
            break;
          }
        }
      }
    }
    return String.format("%.2f", new Object[] { Double.valueOf(hours) });
  }

  public double todayBeginHaveNoRestHours(String vbegintime, String vendtime, String begintime, String endtime)
    throws ParseException
  {
    double hours = 0.0D;
    SimpleDateFormat ft = new SimpleDateFormat("HH:mm:ss");
    Date s = ft.parse(vbegintime);
    Date e = ft.parse(vendtime);
    Date sp = ft.parse(begintime);
    Date ep = ft.parse(endtime);
    if (e.getTime() <= s.getTime()) {
      hours = 0.0D;
    }
    else if (e.getTime() <= sp.getTime())
      hours = 0.0D;
    else if (s.getTime() >= ep.getTime())
      hours = 0.0D;
    else if ((s.getTime() < sp.getTime()) && (e.getTime() > sp.getTime()) && (e.getTime() < ep.getTime()))
      hours = e.getTime() - sp.getTime();
    else if ((s.getTime() >= sp.getTime()) && (e.getTime() <= ep.getTime()))
      hours = e.getTime() - s.getTime();
    else if ((s.getTime() > sp.getTime()) && (s.getTime() < ep.getTime()) && (e.getTime() > ep.getTime()))
      hours = ep.getTime() - s.getTime();
    else if ((s.getTime() < sp.getTime()) && (e.getTime() > ep.getTime())) {
      hours = ep.getTime() - sp.getTime();
    }

    hours = hours / 1000.0D / 60.0D / 60.0D;
    return hours;
  }

  public double todayBeginHaveRestHours(String vbegintime, String vendtime, String begintime, String endtime, String restbegintime, String restendtime)
    throws ParseException
  {
    double hours = 0.0D;
    SimpleDateFormat ft = new SimpleDateFormat("HH:mm:ss");
    Date s = ft.parse(vbegintime);
    Date e = ft.parse(vendtime);
    Date sp = ft.parse(begintime);
    Date ep = ft.parse(endtime);
    Date sr = ft.parse(restbegintime);
    Date er = ft.parse(restendtime);
    if (e.getTime() <= s.getTime()) {
      hours = 0.0D;
    }
    else if (e.getTime() <= sp.getTime())
      hours = 0.0D;
    else if (s.getTime() >= ep.getTime())
      hours = 0.0D;
    else if ((s.getTime() >= sp.getTime()) && (e.getTime() <= sr.getTime()))
      hours = e.getTime() - s.getTime();
    else if ((s.getTime() >= sr.getTime()) && (e.getTime() <= er.getTime()))
      hours = 0.0D;
    else if ((s.getTime() >= er.getTime()) && (e.getTime() <= ep.getTime()))
      hours = e.getTime() - s.getTime();
    else if ((s.getTime() <= sp.getTime()) && (e.getTime() >= sp.getTime()) && (e.getTime() <= sr.getTime()))
      hours = e.getTime() - sp.getTime();
    else if ((s.getTime() <= sp.getTime()) && (e.getTime() >= sr.getTime()) && (e.getTime() <= er.getTime()))
      hours = sr.getTime() - sp.getTime();
    else if ((s.getTime() <= sp.getTime()) && (e.getTime() >= er.getTime()) && (e.getTime() <= ep.getTime()))
      hours = sr.getTime() - sp.getTime() + (e.getTime() - er.getTime());
    else if ((s.getTime() <= sp.getTime()) && (e.getTime() >= ep.getTime()))
      hours = sr.getTime() - sp.getTime() + (ep.getTime() - er.getTime());
    else if ((s.getTime() >= sp.getTime()) && (s.getTime() <= sr.getTime()) && (e.getTime() >= sr.getTime()) && (e.getTime() <= er.getTime()))
      hours = sr.getTime() - s.getTime();
    else if ((s.getTime() >= sp.getTime()) && (s.getTime() <= sr.getTime()) && (e.getTime() >= er.getTime()) && (e.getTime() <= ep.getTime()))
      hours = sr.getTime() - s.getTime() + (e.getTime() - er.getTime());
    else if ((s.getTime() >= sp.getTime()) && (s.getTime() <= sr.getTime()) && (e.getTime() >= ep.getTime()))
      hours = sr.getTime() - s.getTime() + (ep.getTime() - er.getTime());
    else if ((s.getTime() >= sr.getTime()) && (s.getTime() <= er.getTime()) && (e.getTime() >= er.getTime()) && (e.getTime() <= ep.getTime()))
      hours = e.getTime() - er.getTime();
    else if ((s.getTime() >= sr.getTime()) && (s.getTime() <= er.getTime()) && (e.getTime() >= ep.getTime()))
      hours = ep.getTime() - er.getTime();
    else if ((s.getTime() >= er.getTime()) && (s.getTime() <= ep.getTime()) && (e.getTime() >= ep.getTime())) {
      hours = ep.getTime() - s.getTime();
    }

    hours = hours / 1000.0D / 60.0D / 60.0D;
    return hours;
  }

  public double beginHaveNoRestHours(String vtime, String begintime, String endtime)
    throws ParseException
  {
    double hours = 0.0D;
    SimpleDateFormat ft = new SimpleDateFormat("yyyy-mm-dd HH:mm:ss");
    Date s = ft.parse(vtime);
    Date sp = ft.parse(begintime);
    Date ep = ft.parse(endtime);
    if (s.getTime() <= sp.getTime())
      hours = ep.getTime() - sp.getTime();
    else if ((s.getTime() > sp.getTime()) && (s.getTime() < ep.getTime()))
      hours = ep.getTime() - s.getTime();
    else {
      hours = 0.0D;
    }
    hours = hours / 1000.0D / 60.0D / 60.0D;
    return hours;
  }

  public double endHaveNoRestHours(String vtime, String begintime, String endtime)
    throws ParseException
  {
    double hours = 0.0D;
    SimpleDateFormat ft = new SimpleDateFormat("yyyy-mm-dd HH:mm:ss");
    Date s = ft.parse(vtime);
    Date sp = ft.parse(begintime);
    Date ep = ft.parse(endtime);
    if (s.getTime() <= sp.getTime())
      hours = 0.0D;
    else if ((s.getTime() > sp.getTime()) && (s.getTime() < ep.getTime()))
      hours = s.getTime() - sp.getTime();
    else {
      hours = ep.getTime() - sp.getTime();
    }
    hours = hours / 1000.0D / 60.0D / 60.0D;
    return hours;
  }

  public double beginHaveRestHours(String vtime, String begintime, String endtime, String restbegintime, String restendtime)
    throws ParseException
  {
    double hours = 0.0D;
    SimpleDateFormat ft = new SimpleDateFormat("yyyy-mm-dd HH:mm:ss");
    Date s = ft.parse(vtime);
    Date sp = ft.parse(begintime);
    Date ep = ft.parse(endtime);
    Date sr = ft.parse(restbegintime);
    Date er = ft.parse(restendtime);
    if (s.getTime() <= sp.getTime())
      hours = sr.getTime() - sp.getTime() + (ep.getTime() - er.getTime());
    else if ((s.getTime() > sp.getTime()) && (s.getTime() < sr.getTime()))
      hours = sr.getTime() - s.getTime() + (ep.getTime() + er.getTime());
    else if ((s.getTime() >= sr.getTime()) && (s.getTime() <= er.getTime()))
      hours = ep.getTime() - er.getTime();
    else if ((s.getTime() > er.getTime()) && (s.getTime() < ep.getTime()))
      hours = ep.getTime() - s.getTime();
    else {
      hours = 0.0D;
    }
    hours = hours / 1000.0D / 60.0D / 60.0D;
    return hours;
  }

  public double endHaveRestHours(String vtime, String begintime, String endtime, String restbegintime, String restendtime)
    throws ParseException
  {
    double hours = 0.0D;
    SimpleDateFormat ft = new SimpleDateFormat("yyyy-mm-dd HH:mm:ss");
    Date s = ft.parse(vtime);
    Date sp = ft.parse(begintime);
    Date ep = ft.parse(endtime);
    Date sr = ft.parse(restbegintime);
    Date er = ft.parse(restendtime);
    if (s.getTime() <= sp.getTime())
      hours = 0.0D;
    else if ((s.getTime() > sp.getTime()) && (s.getTime() < sr.getTime()))
      hours = s.getTime() - sp.getTime();
    else if ((s.getTime() >= sr.getTime()) && (s.getTime() <= er.getTime()))
      hours = sr.getTime() - sp.getTime();
    else if ((s.getTime() > er.getTime()) && (s.getTime() < ep.getTime()))
      hours = sr.getTime() - sp.getTime() + (s.getTime() - er.getTime());
    else {
      hours = sr.getTime() - sp.getTime() + (ep.getTime() - er.getTime());
    }
    hours = hours / 1000.0D / 60.0D / 60.0D;
    return hours;
  }

  public double crossDate()
    throws ParseException
  {
    double hours = 0.0D;
    String thetype = "";
    String begindate = "";
    String begintime = "";
    String enddate = "";
    String endtime = "";
    String reqman = "";

    BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    SimpleDateFormat ft = new SimpleDateFormat("yyyy-mm-dd");
    Date bdate = ft.parse(begindate);
    Date edate = ft.parse(enddate);
    int dnums = (int)(edate.getTime() - bdate.getTime()) / 1000 / 60 / 60 / 24;
    Calendar cdr = Calendar.getInstance();
    if (dnums == 1) {
      for (int i = 0; i < dnums + 1; i++) {
        cdr.setTime(bdate);
        cdr.add(5, i);
        String nextDate = ft.format(cdr.getTime());
        String sql = "select a.classno,a.pstime,a.petime,a.rstime,a.retime,a.whours from uf_hr_classinfo a,uf_hr_classplan b where a.requestid=b.classno and b.objname='" + reqman + "' and b.thedate='" + nextDate + "'";
        List ls = baseJdbcDao.executeSqlForList(sql);
        if (ls.size() > 0) {
          Map m = (Map)ls.get(0);
          String pstime = StringHelper.null2String(m.get("pstime"));
          String petime = StringHelper.null2String(m.get("petime"));
          String rstime = StringHelper.null2String(m.get("rstime"));
          String retime = StringHelper.null2String(m.get("retime"));
          String classno = StringHelper.null2String(m.get("classno"));
          SimpleDateFormat sft = new SimpleDateFormat("HH:mm:ss");
          if ((thetype.equals("40285a904931f62b014936582eae18d3")) || ((!thetype.equals("40285a904931f62b014936582eae18d3")) && (!classno.equals("OFF")))) {
            Date sp = sft.parse(pstime);
            Date ep = sft.parse(petime);
            if (sp.getTime() >= ep.getTime()) {
              String beginDateTime = begindate + " " + begintime;
              String endDateTime = enddate + " " + endtime;
              pstime = nextDate + " " + pstime;
              cdr.setTime(bdate);
              cdr.add(5, i + 1);
              String dateTwo = ft.format(cdr.getTime());
              petime = dateTwo + " " + petime;
              if (i == 0) {
                if (rstime.equals("")) {
                  hours += beginHaveNoRestHours(beginDateTime, pstime, begindate + " 23:59:59");

                  Date localDate1 = ft.parse(endDateTime);
                }
                else
                {
                  Date sr = sft.parse(rstime);
                  Date er = sft.parse(retime);
                  Date theEnd = sft.parse(nextDate + " 23:59:59");
                  if (sr.getTime() >= er.getTime()) {
                    rstime = nextDate + " " + rstime;
                    retime = dateTwo + " " + retime;
                  } else if (sr.getTime() > theEnd.getTime()) {
                    rstime = dateTwo + " " + rstime;
                    retime = dateTwo + " " + retime;
                  } else {
                    rstime = nextDate + " " + rstime;
                    retime = nextDate + " " + retime;
                  }
                  hours += beginHaveRestHours(beginDateTime, pstime, petime, rstime, retime);
                }
              }
              if (i == 1)
              {
                if (rstime.equals(""))
                  hours += endHaveNoRestHours(nextDate + " " + endtime, nextDate + " " + pstime, nextDate + " " + petime);
                else
                  hours += endHaveRestHours(nextDate + " " + endtime, nextDate + " " + pstime, nextDate + " " + petime, nextDate + " " + rstime, nextDate + " " + retime);
              }
            }
            else {
              if (i == 0) {
                if (rstime.equals(""))
                  hours += beginHaveNoRestHours(begindate + " " + begintime, begindate + " " + pstime, begindate + " " + petime);
                else {
                  hours += beginHaveRestHours(begindate + " " + begintime, begindate + " " + pstime, begindate + " " + petime, begindate + " " + rstime, begindate + " " + retime);
                }
              }
              if (i == 1)
                if (rstime.equals(""))
                  hours += endHaveNoRestHours(enddate + " " + endtime, enddate + " " + pstime, enddate + " " + petime);
                else
                  hours += endHaveRestHours(enddate + " " + endtime, enddate + " " + pstime, enddate + " " + petime, enddate + " " + rstime, enddate + " " + retime);
            }
          }
          else
          {
            hours = 0.0D;
          }
        } else {
          hours = 0.0D;
          break;
        }
      }

    }

    return hours;
  }
}