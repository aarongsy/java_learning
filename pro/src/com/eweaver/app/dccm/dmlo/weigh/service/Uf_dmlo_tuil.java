package com.eweaver.app.dccm.dmlo.weigh.service;

import com.eweaver.base.BaseContext;
import com.eweaver.base.BaseJdbcDao;
import com.eweaver.base.util.NumberHelper;
import com.eweaver.base.util.StringHelper;
import java.io.PrintStream;
import java.util.List;
import java.util.Map;

public class Uf_dmlo_tuil
{
  public String getworth(String plate, String weight)
  {
    String ret = "";
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");

    double tare = 0.0D;
    List list003 = baseJdbc.executeSqlForList("select tare from uf_dmlo_pondrecord where ladingno = '" + plate + "'");
    if (list003.size() > 0) {
      Map map003 = (Map)list003.get(0);
      tare = NumberHelper.string2Double(map003.get("tare"), 0.0D);
    }
    System.out.println("------------------------ plate : " + plate);
    System.out.println("------------------------ 入重 tare : " + tare);
    System.out.println("------------------------ 出重 weight : " + weight);
    baseJdbc.update("update uf_dmlo_provedoc set inweight = '" + tare + "',outweight = '" + weight + "',lastout = to_char(sysdate,'yyyy-MM-dd HH24:mi:ss') where matchno = '" + plate + "' ");

    return ret;
  }

  public String getWeightNote(String runningno, String requestid)
  {
    String ret = "";
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    String remark = "";
    String materialtype = "";
    List list01 = baseJdbc.executeSqlForList("select memo1,packtype materialtype  from uf_dmlo_delivery where runningno = '" + runningno + "'");
    if (list01.size() > 0) {
      Map map01 = (Map)list01.get(0);
      remark = StringHelper.null2String(map01.get("memo1"));
      materialtype = StringHelper.null2String(map01.get("materialtype"));
    }
    List list02 = baseJdbc.executeSqlForList("select bulkflag materialtype from uf_dmlo_purchase where runningno = '" + runningno + "'");
    if (list02.size() > 0) {
      Map map02 = (Map)list02.get(0);
      materialtype = StringHelper.null2String(map02.get("materialtype"));
    }
    List list03 = baseJdbc.executeSqlForList("select materialtype from uf_dmlo_salesorder  where runningno = '" + runningno + "'");
    if (list03.size() > 0) {
      Map map03 = (Map)list03.get(0);
      materialtype = StringHelper.null2String(map03.get("materialtype"));
    }
    List list04 = baseJdbc.executeSqlForList("select (select objname from selectitem where id = uf_lo_passdetail.bulkflag) materialtype from uf_lo_passdetail where runningno = '" + runningno + "'");
    if (list04.size() > 0) {
      Map map04 = (Map)list04.get(0);
      materialtype = StringHelper.null2String(map04.get("materialtype"));
    }
    String bzlb = "";
    if (!"".equals(materialtype)) {
      if (("Z01".equals(materialtype)) || ("X".equals(materialtype)))
        bzlb = "散装";
      else {
        bzlb = "固定包装";
      }
      baseJdbc.update("update uf_lo_shipprove set packtype = '" + bzlb + "',remark = '" + remark + "' where requestid = '" + requestid + "'");
    }
    return ret;
  }
}