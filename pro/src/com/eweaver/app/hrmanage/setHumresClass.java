package com.eweaver.app.hrmanage;

import com.eweaver.app.sap.orgunit.Class_ZHR_PERSONAL_DWS_GET;
import com.eweaver.base.BaseContext;
import com.eweaver.base.BaseJdbcDao;
import com.eweaver.base.util.StringHelper;
import java.io.PrintStream;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;
import java.util.Map;

public class setHumresClass
{
  public void check()
  {
    try
    {
      BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
      SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");
      Calendar c = Calendar.getInstance();
      c.add(2, 0);
      c.set(5, 1);
      String first = format.format(c.getTime());

      c.set(5, c.getActualMaximum(5));
      String last = format.format(c.getTime());

      Class_ZHR_PERSONAL_DWS_GET app = new Class_ZHR_PERSONAL_DWS_GET("ZHR_PERSONAL_DWS_GET");
      System.out.println("HumresClass Timing Synchronization Start !!!");
      String sql = "select objno from humres where isdelete=0 and hrstatus='4028804c16acfbc00116ccba13802935' and objname <> 'sysadmin'";
      List list = baseJdbc.executeSqlForList(sql);
      if (list.size() > 0) {
        for (int i = 0; i < list.size(); i++) {
          Map map = (Map)list.get(i);
          String objno = StringHelper.null2String(map.get("objno"));

          app.syncClass(objno, first, last);
        }
      }
      System.out.println("HumresClass Timing Synchronization SUCCESS OVER !!!");
      System.out.println("OVER TIME == " + c.getTime());
    } catch (ParseException e) {
      e.printStackTrace();
    }
  }
}