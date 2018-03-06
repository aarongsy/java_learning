package com.eweaver.attendance.servlet;

import com.eweaver.attendance.dao.AttendanceDao;
import com.eweaver.attendance.model.Attendance;
import com.eweaver.attendance.service.AttendanceService;
import com.eweaver.base.AbstractBaseAction;
import com.eweaver.base.BaseContext;
import com.eweaver.base.DataService;
import com.eweaver.base.security.service.acegi.EweaverUser;
import com.eweaver.base.setitem.model.Setitem;
import com.eweaver.base.setitem.service.SetitemService;
import com.eweaver.base.util.DateHelper;
import com.eweaver.base.util.StringHelper;
import com.eweaver.humres.base.service.HumresService;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.simple.JSONArray;

public class AttendanceAction extends AbstractBaseAction
{
  private AttendanceService attendanceService = null;
  private HumresService humresService = null;

  public AttendanceAction(HttpServletRequest request, HttpServletResponse response)
  {
    super(request, response);
    this.attendanceService = ((AttendanceService)BaseContext.getBean("attendanceService"));
    this.humresService = ((HumresService)BaseContext.getBean("humresService"));
  }

  public void execute()
    throws IOException, ServletException
  {
    String action = getParameter("action").trim();
    Map data = new HashMap();
    PrintWriter out = this.response.getWriter();
    String month = getParameter("month");
    if (StringHelper.isEmpty(month)) month = DateHelper.getCurrentMonth();
    DataService ds = new DataService();
    if (!action.equalsIgnoreCase("save"))
    {
      if (action.equalsIgnoreCase("attendance")) {
        String startDate2 = this.attendanceService.getAttendanceStartDate2();
        String curTime = DateHelper.getCurrentTime();
        String info = null;
        Attendance attend = this.attendanceService.getTodayAttendance(1);
        String val = null;
        String ip = getIpAddr(this.request);
        if (attend == null) {
          attend = new Attendance();
          attend.setAttendance(1);
          attend.setDate1(DateHelper.getCurDateTime());
          attend.setHrmid(BaseContext.getRemoteUser().getId());
          attend.setMemo("签到信息...");
          attend.setIp(ip);
          this.attendanceService.getAttendanceDao().save(attend);
          info = "成功签到,签到时间为:" + attend.getDate1();
          val = "签退";
        } else {
          attend = this.attendanceService.getTodayAttendance(2);
          if (attend == null) {
            attend = new Attendance();
            attend.setAttendance(2);
            attend.setHrmid(BaseContext.getRemoteUser().getId());
            attend.setIp(ip);
            attend.setMemo("签退信息...");
          }
          attend.setDate1(DateHelper.getCurDateTime());
          this.attendanceService.getAttendanceDao().save(attend);
          info = "成功签退,签退时间为:" + attend.getDate1();
          if ((StringHelper.isEmpty(startDate2)) || (curTime.compareTo(startDate2) > 0))
            val = "签退";
          else {
            val = "签到";
          }
        }
        JSONArray ar0 = new JSONArray();
        ar0.add(val);
        ar0.add(info);
        out.print(ar0.toString());
      } else if (action.equalsIgnoreCase("setting"))
      {
        if (this.request.getParameter("startDate") != null) {
          Setitem item = this.attendanceService.getSetitemService().getSetitem("536f2d36f95746faa0b9f6da7d16d431");
          item.setItemvalue(getParameter("startDate"));
          this.attendanceService.getSetitemService().modifySetitem(item);
        }
        if (this.request.getParameter("startDate2") != null) {
          Setitem item = this.attendanceService.getSetitemService().getSetitem("aee98b9c3a3d4541a660f21ad21337ce");
          item.setItemvalue(getParameter("startDate2"));
          this.attendanceService.getSetitemService().modifySetitem(item);
        }
        if (this.request.getParameter("endDate") != null) {
          Setitem item = this.attendanceService.getSetitemService().getSetitem("8cc6440d133f4b0e882b6c7ff54643f4");
          item.setItemvalue(getParameter("endDate"));
          this.attendanceService.getSetitemService().modifySetitem(item);
        }
        if (this.request.getParameter("endDate2") != null) {
          Setitem item = this.attendanceService.getSetitemService().getSetitem("24acbb0207464ab492f09137c88a5a0a");
          item.setItemvalue(getParameter("endDate2"));
          this.attendanceService.getSetitemService().modifySetitem(item);
        }
        if (this.request.getParameter("autoAttend") != null) {
          Setitem item = this.attendanceService.getSetitemService().getSetitem("bdcbccfdc8eb446a906081a2049b70c2");
          item.setItemvalue(getParameter("autoAttend"));
          this.attendanceService.getSetitemService().modifySetitem(item);
        }
        if ("post".equalsIgnoreCase(this.request.getMethod())) {
          Setitem item = this.attendanceService.getSetitemService().getSetitem("0f6163a0d13c49b6aba3c9f6c9fb3e36");
          item.setItemvalue(StringHelper.null2String(getParameter("viewAttendbtn"), "0"));
          this.attendanceService.getSetitemService().modifySetitem(item);
        }
        data.put("viewAttendbtn", Boolean.valueOf("1".equals(this.attendanceService.getAttendanceViewAttendbtn())));
        data.put("startDate", this.attendanceService.getAttendanceStartDate());
        data.put("startDate2", this.attendanceService.getAttendanceStartDate2());
        data.put("endDate", this.attendanceService.getAttendanceEndDate());
        data.put("endDate2", this.attendanceService.getAttendanceEndDate2());
        data.put("autoAttend", Boolean.valueOf(this.attendanceService.isAutoAttendance()));
        ToView("/attendance/attendanceSetting.jsp", data);
      } else if (!action.equalsIgnoreCase("detail"))
      {
        String hrmid = getParameter("hrmid");
        if (StringHelper.isEmpty(hrmid)) hrmid = BaseContext.getRemoteUser().getId();
        data.put("hrmid", hrmid);
        data.put("hrmname", this.humresService.getHrmresNameById(hrmid));
        String startDate = DateHelper.getCurrentMonth() + "-01";
        String endDate = DateHelper.getCurrentDate();
        data.put("startDate", startDate);
        data.put("endDate", endDate);
        data.put("workdayCount", Integer.valueOf(this.attendanceService.getWorkdaysCount(startDate, endDate)));
        data.put("nDays", Integer.valueOf(this.attendanceService.getAttendanceCount(hrmid, startDate, endDate, 0)));
        ToView("/attendance/attendanceList.jsp", data);
      }
    }
  }

  public String getIpAddr(HttpServletRequest request)
  {
    String ip = request.getHeader("x-forwarded-for");
    if ((ip == null) || (ip.length() == 0) || ("unknown".equalsIgnoreCase(ip))) {
      ip = request.getHeader("Proxy-Client-IP");
    }
    if ((ip == null) || (ip.length() == 0) || ("unknown".equalsIgnoreCase(ip))) {
      ip = request.getHeader("WL-Proxy-Client-IP");
    }
    if ((ip == null) || (ip.length() == 0) || ("unknown".equalsIgnoreCase(ip))) {
      ip = request.getRemoteAddr();
    }
    return ip;
  }
}