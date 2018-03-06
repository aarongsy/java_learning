package com.eweaver.attendance.service;

import com.eweaver.attendance.dao.AttendanceDao;
import com.eweaver.attendance.model.Attendance;
import com.eweaver.attendance.model.HolidaysInfo;
import com.eweaver.base.AbstractBaseService;
import com.eweaver.base.BaseContext;
import com.eweaver.base.SQLMap;
import com.eweaver.base.security.service.acegi.EweaverUser;
import com.eweaver.base.setitem.model.Setitem;
import com.eweaver.base.setitem.service.SetitemService;
import com.eweaver.base.util.DateHelper;
import com.eweaver.base.util.NumberHelper;
import com.eweaver.base.util.StringHelper;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Map;

public class AttendanceService extends AbstractBaseService
{
  private SetitemService setitemService;
  private AttendanceDao attendanceDao = null;
  private HolidaysService holidaysService = null;

  public boolean isAutoAttendance()
  {
    Setitem item = this.setitemService.getSetitem("bdcbccfdc8eb446a906081a2049b70c2");
    return (item != null) && ("1".equalsIgnoreCase(item.getItemvalue()));
  }

  public String getAttendanceStartDate()
  {
    Setitem item = this.setitemService.getSetitem("536f2d36f95746faa0b9f6da7d16d431");
    return item != null ? item.getItemvalue() : null;
  }

  public String getAttendanceStartDate2()
  {
    Setitem item = this.setitemService.getSetitem("aee98b9c3a3d4541a660f21ad21337ce");
    return item != null ? item.getItemvalue() : null;
  }

  public String getAttendanceEndDate()
  {
    Setitem item = this.setitemService.getSetitem("8cc6440d133f4b0e882b6c7ff54643f4");
    return item != null ? item.getItemvalue() : null;
  }

  public String getAttendanceEndDate2()
  {
    Setitem item = this.setitemService.getSetitem("24acbb0207464ab492f09137c88a5a0a");
    return item != null ? item.getItemvalue() : null;
  }

  public String getAttendanceViewAttendbtn()
  {
    Setitem item = this.setitemService.getSetitem("0f6163a0d13c49b6aba3c9f6c9fb3e36");
    return item != null ? item.getItemvalue() : null;
  }

  public Attendance getTodayAttendance(int attendanceType)
  {
    String hrmid = BaseContext.getRemoteUser().getId();
    String today = DateHelper.getShortDate(null);
    String curTime = DateHelper.getCurrentTime();
    String endDate = getAttendanceEndDate();
    String startDate2 = getAttendanceStartDate2();

    String hql = SQLMap.getSQLString("com.eweaver.attendance.service.AttendanceService.getTodayAttendance.sql1", new String[] { today, hrmid, String.valueOf(attendanceType) });
    if (!StringHelper.isEmpty(startDate2)) {
      if (attendanceType == 1)
        hql = hql + " " + SQLMap.getSQLString("com.eweaver.attendance.service.AttendanceService.getTodayAttendance.sql2", new String[] { endDate });
      else {
        hql = hql + " " + SQLMap.getSQLString("com.eweaver.attendance.service.AttendanceService.getTodayAttendance.sql3", new String[] { startDate2 });
      }

    }

    hql = hql + " order by date1 DESC";
    List list1 = this.attendanceDao.getList(hql);
    Attendance a = (list1 != null) && (!list1.isEmpty()) ? (Attendance)list1.get(0) : null;

    return a;
  }

  public int getAttendanceCount(String hrmid, String startDate, String endDate, int action)
  {
    int nCount = 0;
    String startTime = getAttendanceStartDate();
    String endTime = getAttendanceEndDate();

    String hql = SQLMap.getSQLString("com.eweaver.attendance.service.AttendanceService.getAttendanceCount", new String[] { hrmid, startDate, endDate });

    if (action == 0) hql = hql + ">'" + startTime + "' and attendance=" + 1;
    else if (action == 1) hql = hql + "<'" + endTime + "' and attendance=" + 2; else
      return nCount;
    List list1 = this.attendanceDao.getList(hql);
    if ((list1 != null) && (!list1.isEmpty())) {
      nCount = NumberHelper.string2Int(list1.get(0), 0);
    }
    return nCount;
  }

  public List<Attendance> getAttendanceList(String hrmid, String startDate, String endDate)
  {
    String hql = SQLMap.getSQLString("com.eweaver.attendance.service.AttendanceService.getAttendanceList", new String[] { hrmid, startDate, endDate });

    return this.attendanceDao.getList(hql);
  }

  public int getAttendanceCount(IQueryAttendance iqa)
  {
    int ret = 0;
    ret = iqa.executeQuery();
    return ret;
  }
  public static int getCount(IQueryAttendance iqa) {
    return iqa.executeQuery() + 1;
  }
  public static void main(String[] args) {
    int n = getCount(new IQueryAttendance() {
      public int executeQuery() {
        return 99;
      }
    });
  }

  public List getWorkdays(String startDate, String endDate)
  {
    List workdaylist = new ArrayList();
    Calendar cal = Calendar.getInstance();
    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
    try {
      cal.setTime(format.parse(startDate)); } catch (ParseException pe) {
      pe.printStackTrace();
    }int nWeek = cal.get(7);
    Map map = this.holidaysService.getMapsByMonth(startDate, endDate);

    int days = (int)DateHelper.getDaysBetween(endDate, startDate);
    String day = null;
    for (int i = 0; i <= days; i++) {
      day = format.format(cal.getTime());
      cal.add(5, 1);

      HolidaysInfo h = (HolidaysInfo)map.get(day);
      if ((nWeek == 1) || (nWeek == 7)) {
        if ((h != null) && (h.getIsWorkday().intValue() == 1))
          workdaylist.add(day);
      }
      else if ((h == null) || (h.getIsHoliday().intValue() != 1)) {
        workdaylist.add(day);
      }
      nWeek++;
      if (nWeek > 7) nWeek = 1;
    }
    return workdaylist;
  }

  public int getWorkdaysCount(String startDate, String endDate)
  {
    int nCount = 0;
    Calendar cal = Calendar.getInstance();
    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
    try {
      cal.setTime(format.parse(startDate)); } catch (ParseException pe) {
      pe.printStackTrace();
    }int nWeek = cal.get(7);
    Map map = this.holidaysService.getMapsByMonth(startDate, endDate);

    int days = (int)DateHelper.getDaysBetween(endDate, startDate);
    String day = null;
    for (int i = 0; i <= days; i++) {
      day = format.format(cal.getTime());
      cal.add(5, 1);

      HolidaysInfo h = (HolidaysInfo)map.get(day);
      if ((nWeek == 1) || (nWeek == 7)) {
        if ((h != null) && (h.getIsWorkday().intValue() == 1))
          nCount++;
      }
      else if ((h == null) || (h.getIsHoliday().intValue() != 1)) {
        nCount++;
      }
      nWeek++;
      if (nWeek > 7) nWeek = 1;
    }
    return nCount;
  }

  public boolean isWorkday() {
    return this.holidaysService.isWorkDayToday();
  }

  public AttendanceDao getAttendanceDao()
  {
    return this.attendanceDao;
  }

  public void setAttendanceDao(AttendanceDao attendanceDao) {
    this.attendanceDao = attendanceDao;
  }

  public SetitemService getSetitemService() {
    return this.setitemService;
  }
  public void setSetitemService(SetitemService setitemService) {
    this.setitemService = setitemService;
  }

  public HolidaysService getHolidaysService() {
    return this.holidaysService;
  }

  public void setHolidaysService(HolidaysService holidaysService) {
    this.holidaysService = holidaysService;
  }
}