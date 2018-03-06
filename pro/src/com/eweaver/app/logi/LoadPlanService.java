package com.eweaver.app.logi;

import com.eweaver.app.weight.service.Uf_lo_budgetService;
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
      ret += ds.executeSql("update uf_lo_loadplan m set m.expfare = '" + String.format("%.2f", new Object[] { Double.valueOf(money) }) + "' where m.requestid = '" + requestid + "'");

      Uf_lo_budgetService bs = new Uf_lo_budgetService();
      ret += bs.createBudgetByAberrant(requestid);
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

  public int loadPlanToCancel(String planno)
  {
    int ret = 0;
    DataService ds = new DataService();

    String qzcx = "update uf_lo_freightclean set state = '40285a8d4b246d79014b2a66cff80b0b' where uf_lo_freightclean.requestid in (select requestid from uf_lo_loadclean where uf_lo_loadclean.loadplanno = '" + 
      planno + "')";
    ret += ds.executeSql(qzcx);

    String dzdcx = "update uf_lo_checkaccount set state = '40285a8d4b246d79014b2a66cff80b0b' where uf_lo_checkaccount.requestid in (select requestid from uf_lo_checkzxzgdetail where uf_lo_checkzxzgdetail.loadplanno = '" + 
      planno + "')";
    ret += ds.executeSql(dzdcx);

    String zgdcx = "update uf_lo_budget set isremark = null where invoiceno in (select invoiceno from uf_lo_loadclean where uf_lo_loadclean.requestid in (select requestid from uf_lo_loadclean where uf_lo_loadclean.loadplanno = '" + 
      planno + "'))";
    ret += ds.executeSql(zgdcx);

    String zgdzf = "update uf_lo_budget set invoicestatue = '402864d149e039b10149e080b01600c2' where invoiceno in (select invoiceno from uf_lo_loadclean where uf_lo_loadclean.loadplanno = '" + 
      planno + "')";
    ret += ds.executeSql(zgdzf);

    String trdcx = "update uf_lo_ladingmain set state ='402864d14940d265014941e9d82900dc' where loadingno = '" + planno + "'";
    ret += ds.executeSql(trdcx);

    String zmcx = "update uf_lo_provedoc set state ='402864d14955f9990149560a733e000c' where loadno = '" + planno + "'";
    ret += ds.executeSql(zmcx);

    String bdcx = "delete uf_lo_pondrecord where ladingno in (select ladingno from uf_lo_ladingmain where loadingno = '" + 
      planno + "')";
    ret += ds.executeSql(bdcx);

    String plancx = "update uf_lo_loadplan set state = '402864d1493b112a01493bfaf09b000c' where requestid = '" + planno + "'";
    ret += ds.executeSql(plancx);

    return ret;
  }
}