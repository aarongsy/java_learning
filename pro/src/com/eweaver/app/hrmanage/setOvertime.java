package com.eweaver.app.hrmanage;

import com.eweaver.base.BaseContext;
import com.eweaver.base.BaseJdbcDao;
import java.util.Calendar;

public class setOvertime
{
  public void check()
  {
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    Calendar cd = Calendar.getInstance();
    int year = cd.get(1);
    int month = cd.get(2);
    String day = "";
    if (month < 10) day = year + "-0" + month + "-21 00:00:00"; else
      day = year + "-" + month + "-21 00:00:00";
    String sql = "update uf_hr_overtime set valid='40288098276fc2120127704884290211' where requestid in (select a.requestid from uf_hr_overtime a,requestbase b where a.valid='40288098276fc2120127704884290210' and a.realstartdate is not null and to_date(a.realstartdate || ' ' || a.realstarttime,'yyyy-MM-dd hh24:mi:ss')<=to_date('" + 
      day + "','yyyy-MM-dd hh24:mi:ss') and a.requestid=b.id and b.isdelete=0 and b.isfinished=0)";
    baseJdbc.update(sql);
  }
}