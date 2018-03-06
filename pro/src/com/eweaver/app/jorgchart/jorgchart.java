package com.eweaver.app.jorgchart;

import com.eweaver.base.BaseContext;
import com.eweaver.base.BaseJdbcDao;
import java.util.List;
import java.util.Map;

public class jorgchart
{
  private StringBuffer buf = new StringBuffer();

  public jorgchart() {
    String orgid = "";
    setBuf(orgid);
  }

  public jorgchart(String orgid) {
    setBuf(orgid);
  }

  public StringBuffer getBuf() {
    return this.buf;
  }
  public void setBuf(String orgid) {
    this.buf = setHtml(orgid);
  }

  public StringBuffer setHtml(String orgid) {
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    String sql = "";
    if (orgid.equals(""))
      sql = "select id,objname from orgunit where isroot=1";
    else {
      sql = "select id,objname from orgunit where id='" + orgid + "'";
    }

    List ls = baseJdbc.executeSqlForList(sql);
    if (ls.size() > 0) {
      Map m = (Map)ls.get(0);
      String id = m.get("id").toString();
      String objname = m.get("objname").toString();
      this.buf.append("<li><span style=\"color: white; width: 100px; padding-top: 15px; font-size: 20px; font-weight: bold;\" id=\"" + id + "\" onmouseover=\"mouseOver('" + id + "')\" onmouseout=\"mouseOut()\">" + objname + "</span>");
      setHtmlSub(id);
      this.buf.append("</li>");
    }
    return this.buf;
  }

  public void setHtmlSub(String id)
  {
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    String sql = "select b.id,b.objname from orgunitlink a,orgunit b where a.oid=b.id and a.pid='" + id + "' and b.unitstatus='402880d31a04dfba011a04e4db5f0003' and b.isdelete=0 order by dsporder asc";
    List ls = baseJdbc.executeSqlForList(sql);
    if (ls.size() > 0) {
      this.buf.append("<ul>");
      for (int k = 0; k < ls.size(); k++) {
        Map m = (Map)ls.get(k);
        String id2 = m.get("id").toString();
        String objname = m.get("objname").toString();
        orginfo org = new orginfo(id2);
        int db = org.getDb();
        int zb = org.getZb();
        int qb = org.getQb();
        String color = "";
        if (qb > 0) color = "#FFFF00";
        else if (qb == 0) color = "#ccccff"; else
          color = "#FFCCCC";
        this.buf.append("<li><span style=\"color:" + color + "\" id=\"" + id2 + "\" onmouseover=\"mouseOver('" + id2 + "')\" onmouseout=\"mouseOut()\">" + objname + "</span>");
        setHtmlSub(id2);
        this.buf.append("</li>");
      }
      this.buf.append("</ul>");
    }
  }
}