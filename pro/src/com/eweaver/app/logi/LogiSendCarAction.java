package com.eweaver.app.logi;

import com.eweaver.base.BaseContext;
import com.eweaver.base.BaseJdbcDao;
import com.eweaver.base.DataService;
import com.eweaver.base.security.service.acegi.EweaverUser;
import com.eweaver.base.util.DateHelper;
import java.util.List;
import java.util.Map;
import org.springframework.jdbc.core.JdbcTemplate;

public class LogiSendCarAction
{
  BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
  DataService dataService = new DataService();

  public String sendAppr(String requestid, String ckmode) throws Exception {
    String flag = "pass";
    String sqlr = "select runningno,deliverdnum from uf_lo_dgcardetail where requestid='" + requestid + "'";
    String sqlt = "select needtype,state from uf_lo_dgcar where requestid='" + requestid + "' ";
    String currentuser = BaseContext.getRemoteUser().getId();
    String currenttime = DateHelper.getCurDateTime();
    List listt = this.baseJdbcDao.executeSqlForList(sqlt);
    String needtype = "";
    String state = "";
    if (listt.size() > 0) {
      needtype = ((Map)listt.get(0)).get("needtype") == null ? "" : ((Map)listt.get(0)).get("needtype").toString();
      state = ((Map)listt.get(0)).get("state") == null ? "" : ((Map)listt.get(0)).get("state").toString();
    }
    String tablename = "";
    if (needtype.equals("402864d14931fb79014932928fae0026"))
      tablename = "uf_lo_delivery";
    else if (needtype.equals("402864d14931fb79014932928fae0027"))
      tablename = "uf_lo_purchase";
    else if (needtype.equals("402864d14931fb79014932928fae0028")) {
      tablename = "uf_lo_salesorder";
    }
    else {
      tablename = "uf_lo_passdetail";
    }

    String psql = "select a.runningno from uf_lo_dgcardetail a," + tablename + " b where a.runningno=b.runningno and nvl(a.deliverdnum,0)>(nvl(b.quantity,0)-nvl(b.yetnum,0)) and a.requestid='" + requestid + "'";
    List plist = this.baseJdbcDao.executeSqlForList(psql);
    if (ckmode.equals("ck1")) {
      if (state.equals("402864d14931fb790149328a92bd0016")) {
        flag = "该派车需求已经审核，请不要重复选择审核！";
        return flag;
      }
      if (plist.size() > 0) {
        flag = "审核失败：";
        for (int m = 0; m < plist.size(); m++) {
          flag = flag + ((Map)plist.get(m)).get("runningno") + ",";
        }
        flag = flag + "流水号超出可派车量,请检查！";
        return flag;
      }
    }
    List list = this.baseJdbcDao.getJdbcTemplate().queryForList(sqlr);
    String upsqld = "";
    String upsql = "";
    String upflag = "";
    for (int i = 0; i < list.size(); i++) {
      if ((ckmode.equals("ck1")) && (state.equals("402864d14931fb790149328a92bd0015"))) {
        upsqld = "update " + tablename + " set yetnum=(select nvl(yetnum,0)+?  yetnum from " + tablename + " where runningno=?) where runningno=?";
        upsql = "update uf_lo_dgcar set state='402864d14931fb790149328a92bd0016',checkman='" + currentuser + "',checkdate='" + currenttime + "',unmkman='',unmkdate='' where requestid='" + requestid + "'";
        upflag = "update " + tablename + " set yetmark='0' where nvl(quantity,0.0)-nvl(yetnum,0.0)<=0 and runningno=?";
      }
      if ((ckmode.equals("ck2")) && (state.equals("402864d14931fb790149328a92bd0016"))) {
        upsqld = "update " + tablename + " set yetnum=(select nvl(yetnum,0)-?  yetnum from " + tablename + " where runningno=?) where runningno=?";
        upsql = "update uf_lo_dgcar set state='402864d14931fb790149328a92bd0015',unmkman='" + currentuser + "',unmkdate='" + currenttime + "',checkman='',checkdate='' where requestid='" + requestid + "'";
        upflag = "update " + tablename + " set yetmark='1' where nvl(quantity,0.0)-nvl(yetnum,0.0)>0 and runningno=?";
      }
      String runningno = ((Map)list.get(i)).get("runningno") == null ? "" : ((Map)list.get(i)).get("runningno").toString();
      Float deliverdnum = Float.valueOf(((Map)list.get(i)).get("deliverdnum") == null ? 0.0F : Float.parseFloat(((Map)list.get(i)).get("deliverdnum").toString()));
      upsqld = upsqld.replaceFirst("[?]", deliverdnum);
      upsqld = upsqld.replaceFirst("[?]", "'" + runningno + "'");
      upsqld = upsqld.replaceFirst("[?]", "'" + runningno + "'");
      upflag = upflag.replaceFirst("[?]", "'" + runningno + "'");

      if (upsqld.length() > 10) {
        this.baseJdbcDao.update(upsqld);
        this.baseJdbcDao.update(upflag);
      }
    }
    int up = 0;
    if (upsql.length() > 10) {
      up = this.baseJdbcDao.update(upsql);
      if (up <= 0)
        flag = "lost";
    }
    else {
      flag = "lost";
    }
    return flag;
  }

  public String writeBack(String reqid, String custsign, String signdate) throws Exception {
    String flag = "examine";
    String sql = "select requestid,sendreqtime from uf_lo_provedoc where requestid='" + reqid + "'";
    List list = this.baseJdbcDao.getJdbcTemplate().queryForList(sql);
    String sendreqtime = "";
    if (list.size() > 0) {
      sendreqtime = ((Map)list.get(0)).get("sendreqtime") == null ? "" : ((Map)list.get(0)).get("sendreqtime").toString();
    }
    String upsqly = "";
    if (Double.parseDouble(sendreqtime.replace("-", "")) - Double.parseDouble(signdate.replace("-", "")) >= 0.0D)
      upsqly = "update uf_lo_provedoc set custsign='" + custsign + "',signdate='" + signdate + "',ontime='40288098276fc2120127704884290210' where requestid='" + reqid + "'";
    else {
      upsqly = "update uf_lo_provedoc set custsign='" + custsign + "',signdate='" + signdate + "',ontime='40288098276fc2120127704884290211' where requestid='" + reqid + "'";
    }
    this.baseJdbcDao.update(upsqly);

    return flag;
  }
}