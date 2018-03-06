package com.eweaver.app.dccm.dmlo.weigh;


import com.eweaver.base.DataService;
import com.eweaver.base.util.NumberHelper;
import java.util.List;
import java.util.Map;

public class LoadPlanService
{
  public int planningFreightExes(double money, String ids)
  {
    int ret = 0;
    if ((ids.length() > 0) && (money > 0.0D)) {
      DataService ds = new DataService();
      String sql1 = "select sum(m.miles*l.deliverdnum) from uf_dmlo_transhortdetail l left join dmloadplan_miles_view m on l.requestid = m.requestid and substr(l.shiptoaddress,0,4) = m.city where l.requestid = '" + 
        ids + "'";
      double counts = NumberHelper.string2Double(ds.getValue(sql1), 0.0D);
      String sql2 = "select l.id,m.miles,l.deliverdnum,m.miles*l.deliverdnum cou from uf_dmlo_transhortdetail l left join dmloadplan_miles_view m on l.requestid = m.requestid and substr(l.shiptoaddress,0,4) = m.city where l.requestid = '" + 
        ids + "'";
      List retlist = ds.getValues(sql2);
      for (int i = 0; i < retlist.size(); i++) {
        Map m = (Map)retlist.get(i);
        double c = NumberHelper.string2Double(m.get("cou"), 0.0D);
        ret += ds.executeSql("update uf_dmlo_transhortdetail d set d.divvyfee = '" + String.format("%.2f", new Object[] { Double.valueOf(money * c / counts) }) + "' where id = '" + m.get("id") + "'");
      }
    }
    System.out.println("planningExes return ================ : " + ret);
    return ret;
  }
}