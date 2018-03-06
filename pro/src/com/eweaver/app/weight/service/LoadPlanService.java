package com.eweaver.app.weight.service;

import com.eweaver.base.DataService;
import com.eweaver.base.util.NumberHelper;
import com.eweaver.base.util.StringHelper;
import java.io.PrintStream;
import java.util.List;
import java.util.Map;

public class LoadPlanService
{
  public int apportion(String requestid)
  {
    int ret = 0;
    DataService ds = new DataService();
    List list = ds.getValues("select e.ammount,e.loadorderno from uf_lo_excepfees e where e.requestid = '" + requestid + "'");
    if ((list != null) && (list.size() > 0)) {
      Map m = (Map)list.get(0);
      double money = NumberHelper.string2Double(m.get("ammount"), 0.0D);
      String ids = StringHelper.null2String(m.get("loadorderno"));
      ret = planningExes(money, ids);
    }
    return ret;
  }

  public int planningExes(double money, String ids)
  {
    int ret = 0;
    if ((ids.length() > 0) && (money > 0.0D)) {
      DataService ds = new DataService();
      String[] strs = ids.split(",");
      String requestid = strs[0].substring(0, 32);
      String runningnos = "";
      for (int i = 0; i < strs.length; i++) {
        runningnos = runningnos + "'" + strs[i].substring(32) + "',";
      }
      runningnos = "(" + runningnos.substring(0, runningnos.length() - 1) + ")";

      String sql1 = "select sum(m.miles*l.deliverdnum) from uf_lo_loaddetail l left join loadplan_miles_view m on l.requestid = m.requestid and substr(l.shiptoaddress,0,4) = m.city where l.requestid = '" + 
        requestid + "'" + 
        " and substr(runningno,0,10) in " + runningnos;
      double counts = NumberHelper.string2Double(ds.getValue(sql1), 0.0D);
      String sql2 = "select l.id,m.miles,l.deliverdnum,m.miles*l.deliverdnum cou from uf_lo_loaddetail l left join loadplan_miles_view m on l.requestid = m.requestid and substr(l.shiptoaddress,0,4) = m.city where l.requestid = '" + 
        requestid + "'" + 
        " and substr(runningno,0,10) in " + runningnos;
      List retlist = ds.getValues(sql2);
      for (int i = 0; i < retlist.size(); i++) {
        Map m = (Map)retlist.get(i);
        double c = NumberHelper.string2Double(m.get("cou"), 0.0D);
        ret += ds.executeSql("update uf_lo_loaddetail d set d.divvyexpfee = '" + String.format("%.2f", new Object[] { Double.valueOf(money * c / counts) }) + "' where id = '" + m.get("id") + "'");
      }
    }
    System.out.println("planningExes return ================ : " + ret);
    return ret;
  }

  public int planningFreightExes(double money, String ids)
  {
    int ret = 0;
    if ((ids.length() > 0) && (money > 0.0D)) {
      DataService ds = new DataService();
      String sql1 = "select sum(m.miles*l.deliverdnum) from uf_lo_loaddetail l left join loadplan_miles_view m on l.requestid = m.requestid and substr(l.shiptoaddress,0,4) = m.city where l.requestid = '" + 
        ids + "'";
      double counts = NumberHelper.string2Double(ds.getValue(sql1), 0.0D);
      String sql2 = "select l.id,m.miles,l.deliverdnum,m.miles*l.deliverdnum cou from uf_lo_loaddetail l left join loadplan_miles_view m on l.requestid = m.requestid and substr(l.shiptoaddress,0,4) = m.city where l.requestid = '" + 
        ids + "'";
      List retlist = ds.getValues(sql2);
      for (int i = 0; i < retlist.size(); i++) {
        Map m = (Map)retlist.get(i);
        double c = NumberHelper.string2Double(m.get("cou"), 0.0D);
        ret += ds.executeSql("update uf_lo_loaddetail d set d.divvyfee = '" + String.format("%.2f", new Object[] { Double.valueOf(money * c / counts) }) + "' where id = '" + m.get("id") + "'");
      }
    }
    System.out.println("planningExes return ================ : " + ret);
    return ret;
  }
}