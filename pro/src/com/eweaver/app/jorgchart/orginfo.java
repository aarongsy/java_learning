package com.eweaver.app.jorgchart;

import com.eweaver.base.BaseContext;
import com.eweaver.base.BaseJdbcDao;
import java.util.List;
import java.util.Map;

public class orginfo
{
  private int ucount;
  private int db;
  private int zb;
  private int qb;

  public orginfo(String orgid)
  {
    setUcount(orgid);
    setDb(orgid);
    setZb(orgid);
    setQb();
  }
  public int getUcount() {
    return this.ucount;
  }
  public void setUcount(String orgid) {
    this.ucount = haveCount(orgid);
  }
  public int getDb() {
    return this.db;
  }
  public void setDb(String orgid) {
    this.db = haveDb(orgid);
  }
  public int getZb() {
    return this.db;
  }
  public void setZb(String orgid) {
    this.zb = haveZb(orgid);
  }
  public int getQb() {
    return this.qb;
  }
  public void setQb() {
    this.qb = (this.db - this.zb);
  }

  public int haveCount(String orgid) {
    int gws = 0;
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    String sql = "select count(a.id) gws from stationinfo a where exists (select id from (SELECT id FROM (SELECT a.id,a.objname,b.pid FROM ORGUNIT a,ORGUNITLINK b WHERE a.ID=b.OID and a.isdelete=0 and a.unitstatus='402880d31a04dfba011a04e4db5f0003') orgu START WITH orgu.id='" + orgid + "' CONNECT BY PRIOR ORGU.id=orgu.pid) b where a.orgid=b.id) and a.STATIONSTATUS='402880d319eb81720119eba4e1e70004' and a.isdelete=0";
    List ls = baseJdbc.executeSqlForList(sql);
    if (ls.size() > 0) {
      Map m = (Map)ls.get(0);
      gws = Integer.parseInt(m.get("gws").toString());
    }
    return gws;
  }

  public int haveDb(String orgid) {
    int db = 0;
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    String sql = "select NVL(sum(a.MAXNUM),0) db from stationinfo a where exists (select id from (SELECT id FROM (SELECT a.id,a.objname,b.pid FROM ORGUNIT a,ORGUNITLINK b WHERE a.ID=b.OID and a.isdelete=0 and a.unitstatus='402880d31a04dfba011a04e4db5f0003') orgu START WITH orgu.id='" + orgid + "' CONNECT BY PRIOR ORGU.id=orgu.pid) b where a.orgid=b.id) and a.STATIONSTATUS='402880d319eb81720119eba4e1e70004' and a.isdelete=0";
    List ls = baseJdbc.executeSqlForList(sql);
    if (ls.size() > 0) {
      Map m = (Map)ls.get(0);
      db = Integer.parseInt(m.get("db").toString());
    }
    return db;
  }

  public int haveZb(String orgid) {
    int zb = 0;
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    String sql = "select NVL(sum(a.CURNUM),0) zb from stationinfo a where exists (select id from (SELECT id FROM (SELECT a.id,a.objname,b.pid FROM ORGUNIT a,ORGUNITLINK b WHERE a.ID=b.OID and a.isdelete=0 and a.unitstatus='402880d31a04dfba011a04e4db5f0003') orgu START WITH orgu.id='" + orgid + "' CONNECT BY PRIOR ORGU.id=orgu.pid) b where a.orgid=b.id) and a.STATIONSTATUS='402880d319eb81720119eba4e1e70004' and a.isdelete=0";
    List ls = baseJdbc.executeSqlForList(sql);
    if (ls.size() > 0) {
      Map m = (Map)ls.get(0);
      zb = Integer.parseInt(m.get("zb").toString());
    }
    return zb;
  }
}