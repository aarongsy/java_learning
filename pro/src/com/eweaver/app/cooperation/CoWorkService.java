package com.eweaver.app.cooperation;

import com.eweaver.base.BaseContext;
import com.eweaver.base.BaseJdbcDao;
import com.eweaver.base.DataService;
import com.eweaver.base.IDGernerator;
import com.eweaver.base.Page;
import com.eweaver.base.SQLMap;
import com.eweaver.base.label.service.LabelCustomService;
import com.eweaver.base.orgunit.service.OrgunitService;
import com.eweaver.base.refobj.model.Refobj;
import com.eweaver.base.refobj.service.RefobjService;
import com.eweaver.base.security.service.acegi.EweaverUser;
import com.eweaver.base.selectitem.model.Selectitem;
import com.eweaver.base.selectitem.service.SelectitemService;
import com.eweaver.base.util.DateHelper;
import com.eweaver.base.util.NumberHelper;
import com.eweaver.base.util.StringHelper;
import com.eweaver.cowork.model.Coworkset;
import com.eweaver.document.base.model.Attach;
import com.eweaver.document.base.service.AttachService;
import com.eweaver.humres.base.service.HumresService;
import com.eweaver.workflow.form.dao.FormfieldDao;
import com.eweaver.workflow.form.dao.ForminfoDao;
import com.eweaver.workflow.form.model.Formfield;
import com.eweaver.workflow.form.model.Forminfo;
import com.eweaver.workflow.form.service.FormfieldService;
import com.eweaver.workflow.request.service.FormService;
import java.io.PrintStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.springframework.jdbc.core.JdbcTemplate;

public class CoWorkService
{
  private BaseJdbcDao baseJdbcDao;
  private ForminfoDao forminfoDao;
  private FormfieldDao formfieldDao;
  private RefobjService refobjService;
  private int savemode = 1;
  private EweaverUser eu = BaseContext.getRemoteUser();
  private DataService ds = new DataService();
  private Coworkset coworkset;
  private FormService formService;

  public CoWorkService()
  {
    this.baseJdbcDao = ((BaseJdbcDao)BaseContext.getBean("baseJdbcDao"));
    this.forminfoDao = ((ForminfoDao)BaseContext.getBean("forminfoDao"));
    this.formfieldDao = ((FormfieldDao)BaseContext.getBean("formfieldDao"));
    this.refobjService = ((RefobjService)BaseContext.getBean("refobjService"));
    this.ds = new DataService();
    this.coworkset = CoworkHelper.getCoworkset();
    this.formService = ((FormService)BaseContext.getBean("formService"));
  }

  public Map saveFormData(Map workflowparameters)
  {
    ArrayList sqllist = getSaveDataSql(workflowparameters);
    for (int i = 0; i < sqllist.size(); i++) {
      Object sql = sqllist.get(i);
      if ((sql instanceof String)) {
        if (!StringHelper.isEmpty((String)sql)) {
          this.baseJdbcDao.update((String)sql);
        }
      }
      else if ((sql instanceof ArrayList)) {
        String sqlstr = (String)((ArrayList)sql).get(0);
        ArrayList clobs = (ArrayList)((ArrayList)sql).get(1);
        this.baseJdbcDao.update(sqlstr, clobs.toArray());
      }
    }
    String replydate = StringHelper.null2String(workflowparameters.get("field_" + this.coworkset.getReplydate()));
    String replytime = StringHelper.null2String(workflowparameters.get("field_" + this.coworkset.getReplytime()));
    String requestid = StringHelper.null2String(workflowparameters.get("requestid"));
    String coworkrequestid = StringHelper.null2String(workflowparameters.get("coworkrequestid"));
    String operatetype = StringHelper.null2String(workflowparameters.get("operatetype"));
    if ("reply".equals(operatetype)) {
      int storey = NumberHelper.string2Int(this.ds.getValue("select count(*) from COWORKREPLYBASE where pid='" + coworkrequestid + "' and isdelete=0"), 0) + 1;
      this.baseJdbcDao.update("insert into COWORKREPLYBASE (id,pid,operator,operatedate,operatetime,storey,isdelete) values ('" + requestid + "','" + coworkrequestid + "','" + this.eu.getId() + "','" + replydate + "','" + replytime + "','" + storey + "',0)");
    }
    else if (this.savemode == 0) {
      this.baseJdbcDao.update("insert into COWORKBASE (ID,CREATOR,CREATEDATE,CREATETIME,MODIFIER,MODIFYDATE,MODIFYTIME,ISDELETE,isclose) values ('" + requestid + "','" + this.eu.getId() + "','" + DateHelper.getCurrentDate() + "','" + DateHelper.getCurrentTime() + "','" + this.eu.getId() + "','" + DateHelper.getCurrentDate() + "','" + DateHelper.getCurrentTime() + "',0,0)");

      this.baseJdbcDao.update("insert into COWORKTAGLINK (id,requestid,tagid,isdelete) values ('" + IDGernerator.getUnquieID() + "','" + requestid + "','402881e83abf0214013abf0220810290',0)");

      this.baseJdbcDao.update("insert into coworklog (id,deliverid,coworkid,operator,operatedate,operatetime,replyid,operatetype,isdelete) values ('" + IDGernerator.getUnquieID() + "','','" + requestid + "','" + this.eu.getId() + "','" + DateHelper.getCurrentDate() + "','" + DateHelper.getCurrentTime() + "','',1,0)");

      String sql = "insert into coworkrule (id,requestid,orgid,creator,createdate,createtime,coworklevel,begindate,begintime,datetype,enddate,endtime,isshowunread,isreply,isshowreply,isquote,isshowadd,viewtype,showlayoutid,showaddlayout,isdelete) values ('" + IDGernerator.getUnquieID() + "','" + requestid + "','" + this.eu.getOrgid() + "','" + this.eu.getId() + "','" + DateHelper.getCurrentDate() + "','" + DateHelper.getCurrentTime() + "','0','" + DateHelper.getCurrentDate() + "','" + DateHelper.getCurrentTime() + "','0','','','0','0','0','0','0','0','" + CoworkHelper.getParams("defshow1") + "','" + CoworkHelper.getParams("defshow2") + "',0)";

      this.baseJdbcDao.update(sql);
    } else {
      this.baseJdbcDao.update("update COWORKBASE set MODIFIER='" + this.eu.getId() + "',MODIFYDATE='" + DateHelper.getCurrentDate() + "',MODIFYTIME='" + DateHelper.getCurrentTime() + "'  where id='" + requestid + "'");

      this.baseJdbcDao.update("insert into coworklog (id,deliverid,coworkid,operator,operatedate,operatetime,replyid,operatetype,isdelete) values ('" + IDGernerator.getUnquieID() + "','','" + requestid + "','" + this.eu.getId() + "','" + DateHelper.getCurrentDate() + "','" + DateHelper.getCurrentTime() + "','',2,0)");
    }

    return workflowparameters;
  }

  public String getMyCoworkids(String userid, String type) {
    if (userid == null) {
      userid = this.eu.getId();
    }
    StringBuffer ids = new StringBuffer("");
    if ("4".equals(type)) {
      List closelist = this.baseJdbcDao.executeSqlForList("select id from coworkbase where isclose='1' and isdelete=0");
      if ((closelist != null) && (closelist.size() > 0)) {
        for (Map m : closelist) {
          Map user = getCoworkOperator((String)m.get("id"), "1");
          if (user.containsKey(userid)) {
            ids.append((String)m.get("id") + ",");
          }

          Map user1 = getCoworkOperator((String)m.get("id"), "2");
          if (user1.containsKey(userid))
            ids.append((String)m.get("id") + ",");
        }
      }
    }
    else if ("5".equals(type)) {
      String sql = "";
      if ("1".equals(SQLMap.getDbtype()))
        sql = "SELECT requestid FROM coworkrule WHERE datetype=1 and enddate+' '+SUBSTRING(endtime,len('0'+endtime)-7,len('0'+endtime)) < CONVERT(varchar, getdate(), 120 ) and isdelete=0 GROUP BY requestid";
      else if ("2".equals(SQLMap.getDbtype())) {
        sql = "SELECT requestid FROM coworkrule WHERE datetype=1 and to_date(enddate||' '|| to_char(to_date(endtime,'HH24:mi:ss'),'HH24:mi:ss'),'yyyy-MM-dd HH24:mi:ss') < to_date(to_char(SYSDATE,'yyyy-MM-dd HH24:mi:ss'),'yyyy-MM-dd HH24:mi:ss') and isdelete=0 GROUP BY requestid";
      }
      List stoplist = this.baseJdbcDao.executeSqlForList(sql);
      if ((stoplist != null) && (stoplist.size() > 0))
        for (Map m : stoplist) {
          Map user = getCoworkOperator((String)m.get("requestid"), "0");
          if (user.containsKey(userid))
            ids.append((String)m.get("requestid") + ",");
        }
    }
    else
    {
      String sql = "select id from coworkbase where isdelete=0";
      List list = this.ds.getValues(sql);
      if ((list != null) && (list.size() > 0)) {
        for (Map m : list) {
          if ("1".equals(type)) {
            Map user = getCoworkOperator((String)m.get("id"), "0");
            if (user.containsKey(userid))
              ids.append((String)m.get("id") + ",");
          }
          else if ("2".equals(type)) {
            Map user = getCoworkOperator((String)m.get("id"), "3");
            Map user1 = getCoworkOperator((String)m.get("id"), "1");
            Map user2 = getCoworkOperator((String)m.get("id"), "2");
            if ((user.containsKey(userid)) && (!user1.containsKey(userid)) && (!user2.containsKey(userid)))
              ids.append((String)m.get("id") + ",");
          }
          else if ("3".equals(type)) {
            Map user = getCoworkOperator((String)m.get("id"), "1");
            if (user.containsKey(this.eu.getId())) {
              ids.append((String)m.get("id") + ",");
            }
            user = getCoworkOperator((String)m.get("id"), "2");
            if (user.containsKey(userid)) {
              ids.append((String)m.get("id") + ",");
            }
          }
        }
      }
    }
    if (ids.length() >= 32)
      ids = new StringBuffer(" and ").append(reString(new StringBuffer(ids.substring(0, ids.length() - 1)), "requestid"));
    else if (StringHelper.isEmpty(ids.toString())) {
      ids = new StringBuffer(" and requestid in ('requestid is null')");
    }
    return ids.toString();
  }

  public String getMyCoworkids(String type)
  {
    return getMyCoworkids(null, type);
  }

  public Map<String, String> getCoworkOperator(String coworkid, String status)
  {
    Map userids = new HashMap();
    if ("0".equals(status)) {
      String sql = "select * from coworkpermission where requestid='" + coworkid + "' and isdelete=0";
      userids = getUser(coworkid, sql);
      userids = getAttentionUser(coworkid, userids);
      userids = getCreateUser(coworkid, userids);
    } else if ("1".equals(status)) {
      userids = getCreateUser(coworkid, userids);
    } else if ("2".equals(status)) {
      String sql = "select * from coworkpermission where requestid='" + coworkid + "' and oprule=1 and isdelete=0";
      userids = getUser(coworkid, sql);
    } else if ("3".equals(status)) {
      String sql = "select * from coworkpermission where requestid='" + coworkid + "' and oprule=0 and isdelete=0";
      userids = getUser(coworkid, sql);
      userids = getAttentionUser(coworkid, userids);
    } else if ("4".equals(status)) {
      userids = getAttentionUser(coworkid, userids);
    } else if ("5".equals(status)) {
      String sql = "select * from coworkpermission where requestid='" + coworkid + "' and isdelete=0";
      userids = getUser(coworkid, sql);
      userids = getCreateUser(coworkid, userids);
    }

    return userids;
  }

  public List<Map<String, Object>> getReplyList(String requestid, int curePage_p, int sum, String formobjname, String operatedatefield, String operatetimefield, String replyfield, String replyuserfield, int showRownum, Map<String, String> searchMap)
  {
    int start = 0;
    int end = showRownum;
    int curePage = 1;
    if (1 < curePage_p) {
      curePage = curePage_p;
      start = curePage * showRownum - showRownum;
      end = start + showRownum;
    }

    int pageCount = sum / showRownum;
    if (sum % showRownum > 0) {
      pageCount++;
    }
    String replycontent = (String)searchMap.get("searchcontent");
    String begindate = (String)searchMap.get("begindate");
    String enddate = (String)searchMap.get("enddate");
    String utterer = (String)searchMap.get("utterer");
    String rownumber = (String)searchMap.get("rownumber");
    String sql = "select * from " + formobjname + "  WHERE 1=1 ";
    if (!StringHelper.isEmpty(replycontent)) {
      sql = sql + " and " + replyfield + " like  '%" + replycontent + "%' ";
    }
    if (!StringHelper.isEmpty(utterer)) {
      sql = sql + " and " + replyuserfield + " in ('" + utterer.replace(",", "','") + "') ";
    }
    if (!StringHelper.isEmpty(begindate)) {
      sql = sql + " and '" + begindate + "'<=" + operatedatefield + " ";
    }
    if (!StringHelper.isEmpty(enddate)) {
      sql = sql + " and " + operatedatefield + "<='" + enddate + "' ";
    }
    sql = sql + " and requestid in (select id from COWORKREPLYBASE where pid='" + requestid + "' ";
    if (!StringHelper.isEmpty(rownumber)) {
      sql = sql + " and storey='" + rownumber + "' ";
    }
    sql = sql + " and isdelete=0)  order by " + operatedatefield + " desc," + operatetimefield + " desc";

    Page reportpage = this.ds.pagedQuery(sql.toLowerCase(), curePage, showRownum);
    List list = new ArrayList();
    if (reportpage.getTotalSize() > 0) {
      list = (List)reportpage.getResult();
    }
    return list;
  }

  public String getStopCoworkids()
  {
    return getStopCoworkids(null);
  }

  public String getStopCoworkids(String userid)
  {
    if (userid == null) {
      userid = this.eu.getId();
    }
    StringBuffer ids = new StringBuffer("");
    String sql = "select id from COWORKBASE where isdelete=0 and creator != '" + userid + "' and isclose=1";
    List list = this.baseJdbcDao.executeSqlForList(sql);
    if ((list != null) && (list.size() > 0)) {
      for (Map m : list) {
        Map user1 = getCoworkOperator((String)m.get("id"), "2");
        if (!user1.containsKey(userid)) {
          ids.append((String)m.get("id") + ",");
        }
      }
    }
    if (ids.length() >= 32)
      ids = new StringBuffer(" and ").append(reStringNot(new StringBuffer(ids.substring(0, ids.length() - 1)), "requestid"));
    else if (StringHelper.isEmpty(ids.toString())) {
      ids = new StringBuffer(" ");
    }
    return ids.toString();
  }

  private Map<String, String> getAttentionUser(String coworkid, Map<String, String> userids)
  {
    String sql = "SELECT fieldname FROM formfield WHERE id='" + this.coworkset.getCoworktype() + "' and isdelete=0";
    String coworktypefieldname = this.ds.getValue(sql);
    sql = "SELECT objtablename FROM forminfo WHERE ID ='" + this.coworkset.getFormid() + "'";
    String coworkTable = this.ds.getValue(sql);
    sql = "select " + coworktypefieldname + " from " + coworkTable + " where requestid='" + coworkid + "'";
    String coworktypevalue = this.ds.getValue(sql);
    sql = "SELECT fieldname FROM formfield WHERE id='" + this.coworkset.getFunctionary() + "' and isdelete=0";
    String functionary = this.ds.getValue(sql);
    sql = "SELECT reftable FROM refobj WHERE ID IN ( SELECT fieldtype FROM formfield WHERE id='" + this.coworkset.getCoworktype() + "' and isdelete=0)";
    String reftable = this.ds.getValue(sql);
    sql = "select " + functionary + " from " + reftable + " where requestid='" + coworktypevalue + "'";
    String userid = this.ds.getValue(sql);
    List list = this.baseJdbcDao.executeSqlForList("select id,objname from humres where id in ('" + userid.replace(",", "','") + "') and HRSTATUS='4028804c16acfbc00116ccba13802935' AND (WORKSTATUS <>'402881ea0b1c751a010b1cd2ae770008' OR WORKSTATUS IS NULL) AND isdelete=0");
    if ((list != null) && (list.size() > 0)) {
      for (Map m : list) {
        if (!userids.containsKey(m.get("id"))) {
          userids.put(m.get("id"), m.get("objname"));
        }
      }
    }
    return userids;
  }

  private Map<String, String> getCreateUser(String coworkid, Map<String, String> userids)
  {
    List list = this.baseJdbcDao.executeSqlForList("select creator from coworkbase where id='" + coworkid + "'");
    if ((list != null) && (list.size() > 0)) {
      for (Map m : list) {
        if (!userids.containsKey(m.get("creator"))) {
          userids.put(m.get("creator"), StringHelper.null2String(this.ds.getValue("select objname from humres where id='" + (String)m.get("creator") + "'  and HRSTATUS='4028804c16acfbc00116ccba13802935' AND (WORKSTATUS <>'402881ea0b1c751a010b1cd2ae770008' OR WORKSTATUS IS NULL) AND isdelete=0")));
        }
      }
    }
    return userids;
  }

  private Map<String, String> getUser(String coworkid, String sql)
  {
    Map userids = new HashMap();
    List list = this.baseJdbcDao.executeSqlForList(sql);
    if ((list != null) && (list.size() > 0)) {
      for (Map m : list) {
        String opunit = StringHelper.null2String(m.get("opunit"));
        String content = StringHelper.null2String(m.get("content"));
        int minseclevel = NumberHelper.string2Int(m.get("minseclevel"), -1);
        int maxseclevel = NumberHelper.string2Int(m.get("maxseclevel"), -1);
        String seclevel = minseclevel > -1 ? " and seclevel>=" + minseclevel + " " : " ";
        seclevel = seclevel + (maxseclevel > -1 ? " and seclevel<=" + maxseclevel + " " : " ");
        if ("0".equals(opunit)) {
          String[] user = content.split(",");
          for (String uid : user) {
            if (!userids.containsKey(uid))
              userids.put(uid, StringHelper.null2String(this.ds.getValue("select objname from humres where id='" + uid + "' " + seclevel + "  and HRSTATUS='4028804c16acfbc00116ccba13802935' AND (WORKSTATUS <>'402881ea0b1c751a010b1cd2ae770008' OR WORKSTATUS IS NULL) AND isdelete=0")));
          }
        }
        else if ("1".equals(opunit)) {
          List l = this.ds.getValues("select id,objname from humres where orgid in ('" + content.replace(",", "','") + "')  and HRSTATUS='4028804c16acfbc00116ccba13802935' AND (WORKSTATUS <>'402881ea0b1c751a010b1cd2ae770008' OR WORKSTATUS IS NULL) AND isdelete=0 " + seclevel);
          if ((l != null) && (l.size() > 0)) {
            for (Map uid : l) {
              if (!userids.containsKey(uid.get("id")))
                userids.put(uid.get("id"), uid.get("objname"));
            }
          }
        }
        else if ("2".equals(opunit)) {
          List l = this.ds.getValues("select id,objname from humres where station in ('" + content.replace(",", "','") + "')  and HRSTATUS='4028804c16acfbc00116ccba13802935' AND (WORKSTATUS <>'402881ea0b1c751a010b1cd2ae770008' OR WORKSTATUS IS NULL) AND isdelete=0 " + seclevel);
          if ((l != null) && (l.size() > 0)) {
            for (Map uid : l) {
              if (!userids.containsKey(uid.get("id")))
                userids.put(uid.get("id"), uid.get("objname"));
            }
          }
        }
        else if ("3".equals(opunit))
        {
          List l = this.ds.getValues("SELECT * FROM humres WHERE ID IN (SELECT userid FROM Sysuserrolelink WHERE roleid in ('" + content.replace(",", "','") + "'))  and HRSTATUS='4028804c16acfbc00116ccba13802935' AND (WORKSTATUS <>'402881ea0b1c751a010b1cd2ae770008' OR WORKSTATUS IS NULL) AND isdelete=0 " + seclevel);
          if ((l != null) && (l.size() > 0)) {
            for (Map uid : l) {
              if (!userids.containsKey(uid.get("id"))) {
                userids.put(uid.get("id"), uid.get("objname"));
              }
            }
          }

          l = this.ds.getValues("select id,objname from humres where station in (SELECT userid FROM Sysuserrolelink WHERE roleid in ('" + content.replace(",", "','") + "'))  and HRSTATUS='4028804c16acfbc00116ccba13802935' AND (WORKSTATUS <>'402881ea0b1c751a010b1cd2ae770008' OR WORKSTATUS IS NULL) AND isdelete=0 " + seclevel);
          if ((l != null) && (l.size() > 0)) {
            for (Map uid : l) {
              if (!userids.containsKey(uid.get("id")))
                userids.put(uid.get("id"), uid.get("objname"));
            }
          }
        }
        else if ("4".equals(opunit)) {
          List l = this.ds.getValues("select id,objname from humres where HRSTATUS='4028804c16acfbc00116ccba13802935' AND (WORKSTATUS <>'402881ea0b1c751a010b1cd2ae770008' OR WORKSTATUS IS NULL) AND isdelete=0" + seclevel);
          if ((l != null) && (l.size() > 0)) {
            for (Map uid : l) {
              if (!userids.containsKey(uid.get("id"))) {
                userids.put(uid.get("id"), uid.get("objname"));
              }
            }
          }
        }
      }
    }
    return userids;
  }

  public String getUnreadids()
  {
    StringBuffer ids = new StringBuffer("");
    List list = this.baseJdbcDao.executeSqlForList("select id from coworkbase where isdelete=0");
    if ((list != null) && (list.size() > 0)) {
      for (Map m : list) {
        if ((getUnreadNum((String)m.get("id")) > 0) || (getReplyNum((String)m.get("id")) > 0) || (getIsNewCoWork((String)m.get("id")))) {
          ids.append((String)m.get("id")).append(",");
        }
      }
    }

    if (ids.length() >= 32)
      ids = new StringBuffer(" and ").append(reString(new StringBuffer(ids.substring(0, ids.length() - 1)), "requestid"));
    else if (StringHelper.isEmpty(ids.toString())) {
      ids = new StringBuffer(" and requestid in ('unread num is 0') ");
    }
    return ids.toString();
  }

  private boolean getIsNewCoWork(String coworkid)
  {
    return getIsNewCoWork(null, coworkid);
  }

  private boolean getIsNewCoWork(String userid, String coworkid)
  {
    if (userid == null) {
      userid = this.eu.getId();
    }
    boolean temp = false;
    Map user = getCoworkOperator(coworkid, "0");
    if ((user != null) && (user.size() > 0)) {
      Set set = user.keySet();
      if (set.contains(this.eu.getId())) {
        String sql = "SELECT count(*) FROM coworklog WHERE coworkid='" + coworkid + "' and OPERATOR='" + this.eu.getId() + "' AND isdelete =0 and (operatetype=3 or operatetype=1)";
        int count = this.baseJdbcDao.getJdbcTemplate().queryForInt(sql);
        if (count <= 0) {
          temp = true;
        }
      }
    }
    return temp;
  }

  public Map<String, String> getUnReadhuman(String requestid) {
    Map userids = getCoworkOperator(requestid, "0");
    String sql = "SELECT * FROM coworklog WHERE coworkid='" + requestid + "' AND isdelete =0 and ( operatetype=4 or operatetype=5 )ORDER BY operatedate DESC,operatetime DESC";
    List loglist = this.baseJdbcDao.executeSqlForList(sql);
    if ((loglist != null) && (loglist.size() > 0)) {
      Map log = (Map)loglist.get(0);
      String operatedate = StringHelper.null2String(log.get("operatedate"));
      String operatetime = StringHelper.null2String(log.get("operatetime"));
      String sql_ = "select OPERATOR from coworklog where coworkid='" + requestid + "' AND isdelete =0 ";
      if ("1".equals(SQLMap.getDbtype()))
        sql_ = sql_ + " and operatedate+' '+SUBSTRING(operatetime,len('0'+operatetime)-7,len('0'+operatetime)) >= '" + operatedate + " '+SUBSTRING('" + operatetime + "',len('0" + operatetime + "')-7,len('0" + operatetime + "')) ";
      else if ("2".equals(SQLMap.getDbtype())) {
        sql_ = sql_ + " and to_date(operatedate||' '|| to_char(to_date(operatetime,'HH24:mi:ss'),'HH24:mi:ss'),'yyyy-MM-dd HH24:mi:ss') >= to_date('" + operatedate + " '|| to_char(to_date('" + operatetime + "','HH24:mi:ss'),'HH24:mi:ss'),'yyyy-MM-dd HH24:mi:ss')";
      }
      List readhumanlist = this.baseJdbcDao.executeSqlForList(sql_);
      for (Map readhuman : readhumanlist) {
        if (userids.containsKey(readhuman.get("operator"))) {
          userids.remove(readhuman.get("operator"));
        }
      }
    }
    return userids;
  }

  public int getUnreadNum(String requestid) {
    return getUnreadNum(null, requestid);
  }

  public int getUnreadNum(String userid, String requestid)
  {
    if (userid == null) {
      userid = this.eu.getId();
    }
    int unread = 0;
    String sql = "SELECT * FROM coworklog WHERE coworkid='" + requestid + "' AND isdelete =0 and OPERATOR='" + userid + "' ORDER BY operatedate DESC,operatetime DESC";
    List loglist = this.baseJdbcDao.executeSqlForList(sql);
    if ((loglist != null) && (loglist.size() > 0)) {
      Map log = (Map)loglist.get(0);
      String operatedate = StringHelper.null2String(log.get("operatedate"));
      String operatetime = StringHelper.null2String(log.get("operatetime"));
      String sql_ = "select count(*) from coworklog where coworkid='" + requestid + "' AND isdelete =0 and (operatetype=4 or operatetype=5) and OPERATOR !='" + userid + "' ";
      if ("1".equals(SQLMap.getDbtype()))
        sql_ = sql_ + " and operatedate+' '+SUBSTRING(operatetime,len('0'+operatetime)-7,len('0'+operatetime)) > '" + operatedate + " '+SUBSTRING('" + operatetime + "',len('0" + operatetime + "')-7,len('0" + operatetime + "')) ";
      else if ("2".equals(SQLMap.getDbtype())) {
        sql_ = sql_ + " and to_date(operatedate||' '|| to_char(to_date(operatetime,'HH24:mi:ss'),'HH24:mi:ss'),'yyyy-MM-dd HH24:mi:ss') > to_date('" + operatedate + " '|| to_char(to_date('" + operatetime + "','HH24:mi:ss'),'HH24:mi:ss'),'yyyy-MM-dd HH24:mi:ss')";
      }
      unread = this.baseJdbcDao.getJdbcTemplate().queryForInt(sql_);
    } else {
      unread = getSumReply(requestid);
    }
    return unread;
  }

  public int getReplyNum(String userid, String requestid) {
    if (userid == null) {
      userid = this.eu.getId();
    }
    int replynum = 0;
    String sql = "SELECT * FROM coworklog WHERE coworkid='" + requestid + "' AND isdelete =0 and OPERATOR='" + userid + "' ORDER BY operatedate DESC,operatetime DESC";
    List loglist = this.baseJdbcDao.executeSqlForList(sql);
    if ((loglist != null) && (loglist.size() > 0)) {
      Map log = (Map)loglist.get(0);
      String operatedate = StringHelper.null2String(log.get("operatedate"));
      String operatetime = StringHelper.null2String(log.get("operatetime"));
      String sql_ = "select count(*) from coworklog where coworkid='" + requestid + "' and replyid in (SELECT ID FROM COWORKREPLYBASE WHERE pid='" + requestid + "' AND OPERATOR='" + userid + "') " + " AND isdelete =0 and operatetype=5 and OPERATOR !='" + userid + "' ";

      if ("1".equals(SQLMap.getDbtype()))
        sql_ = sql_ + " and operatedate+' '+SUBSTRING(operatetime,len('0'+operatetime)-7,len('0'+operatetime)) > '" + operatedate + " '+SUBSTRING('" + operatetime + "',len('0" + operatetime + "')-7,len('0" + operatetime + "')) ";
      else if ("2".equals(SQLMap.getDbtype())) {
        sql_ = sql_ + " and to_date(operatedate||' '|| to_char(to_date(operatetime,'HH24:mi:ss'),'HH24:mi:ss'),'yyyy-MM-dd HH24:mi:ss') > to_date('" + operatedate + " '|| to_char(to_date('" + operatetime + "','HH24:mi:ss'),'HH24:mi:ss'),'yyyy-MM-dd HH24:mi:ss')";
      }
      replynum = this.baseJdbcDao.getJdbcTemplate().queryForInt(sql_);
    }
    return replynum;
  }

  public int getReplyNum(String requestid)
  {
    return getReplyNum(null, requestid);
  }

  public List<Map<String, String>> getHumresOrder(String requestid)
  {
    List list = new ArrayList();
    String sql = "SELECT COUNT(*) AS c,(SELECT objname FROM humres WHERE ID=OPERATOR) AS objname,(SELECT imgfile FROM humres WHERE ID=OPERATOR) AS imgfile FROM coworklog WHERE coworkid='" + requestid + "' and isdelete=0 AND (operatetype=4 OR operatetype=5) GROUP BY OPERATOR ORDER BY c DESC";
    list = this.baseJdbcDao.getJdbcTemplate().queryForList(sql);
    return list;
  }

  public static StringBuffer reStringNot(StringBuffer ids, String col) {
    StringBuffer list = new StringBuffer("(");
    if ((ids.indexOf(",") >= 0) || (ids.length() >= 32)) {
      StringBuffer sb = new StringBuffer(" " + col + " not in (");
      String[] agentList = ids.toString().split(",");
      for (int i = 0; i < agentList.length; i++) {
        if (i == agentList.length - 1) {
          sb.append("'").append(agentList[i]).append("')");
        } else if ((i % 999 == 0) && (i > 0)) {
          sb.append("'").append(agentList[i]).append("'").append(")");
          list.append(sb.toString());
          sb = new StringBuffer(" and " + col + " not in (");
        } else {
          sb.append("'").append(agentList[i]).append("',");
        }
      }
      if (agentList.length <= 999) {
        list.append(sb.toString() + ")");
      }
    }
    return list;
  }

  public static StringBuffer reString(StringBuffer ids, String col) {
    StringBuffer list = new StringBuffer("(");
    if ((ids.indexOf(",") >= 0) || (ids.length() >= 32)) {
      StringBuffer sb = new StringBuffer(" " + col + " in (");
      String[] agentList = ids.toString().split(",");
      for (int i = 0; i < agentList.length; i++) {
        if (i == agentList.length - 1) {
          sb.append("'").append(agentList[i]).append("'");
        } else if ((i % 999 == 0) && (i > 0)) {
          sb.append("'").append(agentList[i]).append("'").append(")");
          list.append(sb.toString());
          sb = new StringBuffer(" or " + col + " in (");
        } else {
          sb.append("'").append(agentList[i]).append("',");
        }
      }
      if (agentList.length <= 999) {
        list.append(sb.toString() + ")");
      }
    }
    list.append(")");
    return list;
  }

  public static void main(String[] s) {
    System.out.println(reString(new StringBuffer("11,11,1,11,1,1,1,1,1,1,1,,1,1,1,11,1,1,1,1,1,1,1,"), "requestid"));
  }

  private ArrayList getSaveDataSql(Map parameters) {
    ArrayList ar = new ArrayList();
    String formid = StringHelper.null2String(parameters.get("formid"));
    ArrayList clobs = new ArrayList();
    if (StringHelper.isEmpty(formid))
      return ar;
    Forminfo forminfo = this.forminfoDao.getForminfoById(formid);
    String _tablename = forminfo.getObjtablename();
    if (StringHelper.isEmpty(_tablename))
      return ar;
    List allformfield = this.formfieldDao.getAllFieldByFormId(formid);
    String allupdatefields = "";
    String allupdatevalues = "";
    String allmodifys = "";
    String hasvalueids = StringHelper.null2String(parameters.get("hasValueIDs_" + formid));
    String requestid = StringHelper.null2String(parameters.get("requestid"));
    for (Formfield formfield : allformfield) {
      String _fieldid = StringHelper.null2String(formfield.getId());
      String _fieldname = StringHelper.null2String(formfield.getFieldname());
      String _fieldtype1 = StringHelper.null2String(formfield.getFieldtype());
      String _htmltype = StringHelper.null2String(formfield.getHtmltype());
      String _fieldcheck = StringHelper.null2String(formfield.getFieldcheck()).trim();

      String _fieldtype = "0";
      Integer ismulti = this.refobjService.getRefobj(_fieldtype).getIsmulti();
      if ((ismulti != null) && (ismulti.intValue() == 1)) {
        _fieldtype = "-1";
      }
      if (((_htmltype.equals("1")) && (_fieldtype1.equals("2"))) || ((_htmltype.equals("1")) && (_fieldtype1.equals("3"))) || (_htmltype.equals("4")))
      {
        _fieldtype = "1";
      }if (_htmltype.equals("7"))
        _fieldtype = "2";
      if ((_htmltype.equals("2")) || (_htmltype.equals("3"))) {
        _fieldtype = "-1";
      }
      if ((StringHelper.isID(_fieldid)) && (!_fieldname.equals("")))
      {
        if (_fieldcheck.toUpperCase().startsWith("INCREASE")) {
          String _fieldvalue = getIncreaseValue(_tablename, _fieldname, _fieldcheck);
          allupdatefields = allupdatefields + "," + _fieldname;
          allupdatevalues = allupdatevalues + ",'" + _fieldvalue + "'";
        }
        else
        {
          allupdatefields = allupdatefields + "," + _fieldname;
          String pName = "field_" + _fieldid;
          String pValue = StringHelper.trimToNull((String)parameters.get(pName));
          if (_fieldtype.equals("2")) {
            Set paramKeys = parameters.keySet();
            String pValue2 = "";
            for (String key : paramKeys) {
              if (key.indexOf(pName + "file") > -1) {
                pValue2 = pValue2 + "," + StringHelper.trimToNull((String)parameters.get(key));
              }
            }

            if (!StringHelper.isEmpty(pValue2)) {
              pValue2 = pValue2.substring(1);
              if (!StringHelper.isEmpty(pValue))
                pValue = pValue + "," + pValue2;
              else {
                pValue = pValue2;
              }
            }
          }

          pValue = StringHelper.StringReplace(pValue, "'", "&#39;");
          if (pValue == null) {
            allupdatevalues = allupdatevalues + ",null";
            allmodifys = allmodifys + "," + _fieldname + "= null";
          } else if (_fieldtype.equals("-1")) {
            allupdatevalues = allupdatevalues + ",?";
            allmodifys = allmodifys + "," + _fieldname + "=?";
            clobs.add(pValue);
          } else if (!_fieldtype.equals("1")) {
            allupdatevalues = allupdatevalues + ",'" + pValue + "'";
            allmodifys = allmodifys + "," + _fieldname + "='" + pValue + "'";
          } else {
            allupdatevalues = allupdatevalues + "," + pValue;
            allmodifys = allmodifys + "," + _fieldname + "= " + pValue;
          }
        }
      }
    }

    if (!allmodifys.equals("")) {
      allmodifys = allmodifys.substring(1);
    }
    StringBuffer sb = new StringBuffer();

    String objid = "";
    if ((requestid.equals("")) || (requestid.equals("null"))) {
      objid = IDGernerator.getUnquieID();
      requestid = IDGernerator.getUnquieID();
      parameters.put("requestid", requestid);
      this.savemode = 0;
    }
    if (this.savemode == 0) {
      sb.append("insert into ");
      sb.append(_tablename);
      sb.append(" (id,requestid ");
      sb.append(allupdatefields);
      sb.append(") values(");
      sb.append("'" + objid + "','" + requestid + "'");
      sb.append(allupdatevalues);
      sb.append(")");
    }
    else if (this.savemode == 1) {
      sb.append("update ");
      sb.append(_tablename);
      sb.append(" set ");
      sb.append(allmodifys);
      sb.append(" where requestid = '");
      sb.append(requestid);
      sb.append("'");
    }

    if (clobs.size() > 0) {
      ArrayList l = new ArrayList();
      l.add(sb.toString());
      l.add(clobs);
      ar.add(l);
    } else {
      ar.add(sb.toString());
    }
    return ar;
  }

  private String getIncreaseValue(String tablename, String fieldname, String fieldcheck) {
    String result = "";
    int initvalue = 1;
    int stepvalue = 1;
    if (fieldcheck.toUpperCase().startsWith("INCREASE")) {
      int spos = 9;
      int epos = fieldcheck.indexOf(")", spos);
      if (epos != -1) {
        String _tmpstr = fieldcheck.substring(spos, epos);
        ArrayList checkvalues = StringHelper.string2ArrayList(_tmpstr, ",");
        if (checkvalues.size() > 0)
          initvalue = NumberHelper.string2Int(StringHelper.null2String(checkvalues.get(0)), 1);
        if (checkvalues.size() > 1)
          stepvalue = NumberHelper.string2Int(StringHelper.null2String(checkvalues.get(1)), 1);
      }
    } else {
      return result;
    }

    int maxvalue = 0;
    String sql = "select max(" + fieldname + ") as maxid from " + tablename;
    List list = this.baseJdbcDao.executeSqlForList(sql);
    for (int i = 0; i < list.size(); i++) {
      Map _map = (Map)list.get(i);
      maxvalue = NumberHelper.string2Int(StringHelper.null2String(_map.get("maxid")), initvalue - stepvalue);
    }

    maxvalue += stepvalue;

    return result + maxvalue;
  }

  public List<Map<String, String>> getAddFunList(String fieldid, String requestid, String objtablename, String operatdate, String operattime, String orderfield, int start, int end)
  {
    List htmllist = new ArrayList();
    FormfieldService formfieldService = (FormfieldService)BaseContext.getBean("formfieldService");
    Formfield formfield = formfieldService.getFormfieldById(fieldid);
    String order = orderfield.equalsIgnoreCase("0") ? "desc" : "asc";
    String sql = "select " + formfield.getFieldname() + "," + operatdate + " as odate," + operattime + " as otime from " + objtablename + " where requestid in (select id from COWORKREPLYBASE where pid='" + requestid + "' AND isdelete=0) and " + formfield.getFieldname() + " is not null order by " + operatdate + " " + order + "," + operattime + " " + order;

    int pageSize = end - start;
    int pageNo = end % pageSize > 0 ? end / pageSize + 1 : end / pageSize;
    Page reportpage = this.ds.pagedQuery(sql.toLowerCase(), pageNo, pageSize);
    List list = new ArrayList();
    int total = reportpage.getTotalSize();
    if (total > 0) {
      list = (List)reportpage.getResult();
    }
    if ((list != null) && (list.size() > 0)) {
      for (Map m : list) {
        if ((m != null) && (m.get(formfield.getFieldname()) != null) && (!"".equals(formfield.getFieldname()))) {
          String fieldHtml = getSystableFieldHtml(formfield, "1", m.get(formfield.getFieldname().toLowerCase()) + "");
          String replycontent = CoworkHelper.getParams("replycontent").toLowerCase();
          if (replycontent.trim().equals(formfield.getFieldname().toLowerCase().trim())) {
            fieldHtml = StringHelper.null2String(m.get(formfield.getFieldname().toLowerCase()));
          }
          if (!StringHelper.isEmpty(fieldHtml)) {
            Map m2 = new HashMap();
            m2.put("content", fieldHtml);
            String date = m.get("odate") + " " + m.get("otime");
            m2.put("date", date);
            htmllist.add(m2);
          }
        }
      }
    }
    return htmllist;
  }

  public int getAddFunSum(String fieldid, String requestid, String objtablename, String operatdate, String operattime) {
    FormfieldService formfieldService = (FormfieldService)BaseContext.getBean("formfieldService");
    Formfield formfield = formfieldService.getFormfieldById(fieldid);
    String sql = "select count(*) from " + objtablename + " where requestid in (select id from COWORKREPLYBASE where isdelete=0) and " + formfield.getFieldname() + " is not null ";
    int sum = NumberHelper.string2Int(this.ds.getValue(sql), 0);
    return sum;
  }

  public List<Map<String, String>> getFieldShowHtml(String replyrequestid, String layoutid, String objtablename)
  {
    DataService ds = new DataService();
    List htmllist = new ArrayList();
    FormfieldService formfieldService = (FormfieldService)BaseContext.getBean("formfieldService");
    List showfield = ds.getValues("SELECT fieldname FROM formlayoutfield WHERE layoutid='" + layoutid + "' AND showstyle=2 and isdelete=0");
    if ((showfield != null) && (showfield.size() > 0)) {
      for (Map sf : showfield) {
        Formfield formfield = formfieldService.getFormfieldById((String)sf.get("fieldname"));
        List l = ds.getValues("select " + formfield.getFieldname() + " from " + objtablename + " where requestid='" + replyrequestid + "'");
        if ((l != null) && (l.size() > 0)) {
          Map m = (Map)l.get(0);
          if ((m != null) && (m.get(formfield.getFieldname().toLowerCase()) != null) && (!"".equals(formfield.getFieldname()))) {
            String fieldHtml = getSystableFieldHtml(formfield, "1", m.get(formfield.getFieldname().toLowerCase()) + "");
            if (!StringHelper.isEmpty(fieldHtml)) {
              Map m2 = new HashMap();
              m2.put(formfield.getId(), fieldHtml);
              htmllist.add(m2);
            }
          }
        }
      }
    }
    return htmllist;
  }

  private String getSystableFieldHtml(Formfield formfield, String isview, String _value) {
    LabelCustomService labelCustomService = (LabelCustomService)BaseContext.getBean("labelCustomService");
    SelectitemService selectitemService = (SelectitemService)BaseContext.getBean("selectitemService");
    HumresService humresService = (HumresService)BaseContext.getBean("humresService");
    AttachService attachService = (AttachService)BaseContext.getBean("attachService");
    StringBuffer sb = new StringBuffer();
    String _formid = StringHelper.null2String(formfield.getFormid());
    String _fieldname = StringHelper.null2String(formfield.getFieldname());
    String _htmltype = StringHelper.null2String(formfield.getHtmltype());
    String _fieldtype = StringHelper.null2String(formfield.getFieldtype());
    String _fieldattr = StringHelper.null2String(formfield.getFieldattr());
    String _fieldcheck = StringHelper.null2String(formfield.getFieldcheck());
    String tablename = this.forminfoDao.getForminfoById(_formid).getObjtablename();
    String fieldname = tablename + "." + _fieldname;
    String fieldNameHtml = " eweavername=\"" + fieldname + "\" ";
    String fieldNameSpanHtml = " eweavername=\"" + fieldname + ".span\" ";
    if (_fieldcheck.toUpperCase().startsWith("INCREASE")) {
      _fieldcheck = "";
    }
    if (!_fieldcheck.startsWith("{")) {
      _fieldcheck = StringHelper.replaceString(_fieldcheck, "\\", "\\\\");
    }
    String _style = "";
    int _showtype = 2;
    if ((isview.equals("1")) && (_showtype > 1)) {
      _showtype = 1;
    }
    String _defaultvalue = "";
    String htmlobjname = _fieldname;

    if (_htmltype.equals("1")) {
      if (_fieldtype.equals("1")) {
        switch (_showtype) {
        case 0:
          sb.append("<input type=\"hidden\" " + fieldNameHtml + " name=\"" + htmlobjname + "\" id=\"" + htmlobjname + "\" value=\"" + _value + "\" >");
          sb.append("<span " + _style + "  " + fieldNameSpanHtml + " id=\"" + htmlobjname + "span\" name=\"" + htmlobjname + "span\" >");
          sb.append("</span>");
          break;
        case 1:
          sb.append("<input type=\"hidden\"  " + fieldNameHtml + " name=\"" + htmlobjname + "\" id=\"" + htmlobjname + "\" value=\"" + _value + "\" >");
          sb.append("<span " + _style + " " + fieldNameSpanHtml + "  id=\"" + htmlobjname + "span\" name=\"" + htmlobjname + "span\" >");
          sb.append(_value);
          sb.append("</span>");
        }
      }
      else if (_fieldtype.equals("2")) {
        switch (_showtype) {
        case 0:
          sb.append("<input type=\"hidden\" " + fieldNameHtml + "  name=\"" + htmlobjname + "\"  id=\"" + htmlobjname + "\" value=\"" + _value + "\" >");
          break;
        case 1:
          sb.append("<input type=\"hidden\" " + fieldNameHtml + "  name=\"" + htmlobjname + "\"  id=\"" + htmlobjname + "\" value=\"" + _value + "\" >");
          sb.append("<span " + _style + " " + fieldNameSpanHtml + "  id=\"" + htmlobjname + "span\" name=\"" + htmlobjname + "span\" >");
          sb.append(_value);
          sb.append("</span>");
        }
      }
      else if (_fieldtype.equals("3")) {
        switch (_showtype) {
        case 0:
          sb.append("<input type=\"hidden\" " + fieldNameHtml + "  name=\"" + htmlobjname + "\"  id=\"" + htmlobjname + "\" value=\"" + _value + "\" >");
          break;
        case 1:
          sb.append("<input type=\"hidden\" " + fieldNameHtml + "  name=\"" + htmlobjname + "\"  id=\"" + htmlobjname + "\" value=\"" + _value + "\" >");
          sb.append("<span " + _style + " " + fieldNameSpanHtml + "  id=\"" + htmlobjname + "span\" name=\"" + htmlobjname + "span\" >");
          sb.append(_value);
          sb.append("</span>");
        }
      }
      else if ((_fieldtype.equals("4")) || (_fieldtype.equals("6"))) {
        if ((StringHelper.isEmpty(_fieldattr)) && (StringHelper.isEmpty(_fieldcheck))) {
          _fieldattr = "(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)";
        }
        switch (_showtype) {
        case 0:
          sb.append("<input type=\"hidden\" " + fieldNameHtml + "  name=\"" + htmlobjname + "\"  id=\"" + htmlobjname + "\" value=\"" + _value + "\" >");
          break;
        case 1:
          sb.append("<input type=\"hidden\" " + fieldNameHtml + "  name=\"" + htmlobjname + "\"  id=\"" + htmlobjname + "\" value=\"" + _value + "\" >");
          sb.append("<span id=\"" + htmlobjname + "span\" " + fieldNameSpanHtml + "  name=\"" + htmlobjname + "span\" >");
          sb.append(_value);
          sb.append("</span>");
        }
      }
      else if (_fieldtype.equals("5")) {
        if ((StringHelper.isEmpty(_fieldattr)) && (StringHelper.isEmpty(_fieldcheck))) {
          _fieldattr = "^((\\d)|(1\\d)|(2[0-3])):[0-5]\\d:[0-5]\\d$";
          _fieldcheck = "{startDate:'%H:00:00',dateFmt:'H:mm:ss'}";
        } else if (StringHelper.isEmpty(_fieldcheck)) {
          _fieldcheck = "{startDate:'%H:00:00',dateFmt:'H:mm:ss'}";
        }
        switch (_showtype) {
        case 0:
          sb.append("<input type=\"hidden\" " + fieldNameHtml + "  id=\"" + htmlobjname + "\"  name=\"" + htmlobjname + "\" value=\"" + _value + "\"  " + _style + "  >");
          break;
        case 1:
          sb.append("<input type=\"hidden\" " + fieldNameHtml + "  id=\"" + htmlobjname + "\"  name=\"" + htmlobjname + "\" value=\"" + _value + "\"  " + _style + "  >");
          sb.append("<span id=\"" + htmlobjname + "span\" " + fieldNameSpanHtml + "  name=\"" + htmlobjname + "span\" >");
          sb.append(_value);
          sb.append("</span>");
        }
      }
    }
    else if (_htmltype.equals("2")) {
      switch (_showtype) {
      case 0:
        sb.append("<input type=\"hidden\" " + fieldNameHtml + "  id=\"" + htmlobjname + "\"  name=\"" + htmlobjname + "\" value=\"" + _value + "\"  " + _style + "  >");

        break;
      case 1:
        if (isview.equals("1")) {
          _value = StringHelper.replaceString(_value, "<br>", "\r\n");
          sb.append("<span id=\"" + htmlobjname + "span\" " + fieldNameSpanHtml + "  name=\"" + htmlobjname + "span\" " + _style + "  >");
          sb.append(_value);
          sb.append("</span>");
        } else {
          _value = StringHelper.replaceString(_value, "<br>", "\r\n");
          sb.append("<span id=\"" + htmlobjname + "span\" " + fieldNameSpanHtml + "  name=\"" + htmlobjname + "span\" " + _style + "  >");
          sb.append(_value);
          sb.append("</span>");
          sb.append("<TEXTAREA style=\"display:none\" " + fieldNameHtml + "  class=\"InputStyle3\"  id=\"" + htmlobjname + "\" name=\"" + htmlobjname + "\" " + _style + "  >");
          sb.append(_value);
          sb.append("</TEXTAREA>");
        }
        break;
      }
    } else if (_htmltype.equals("3")) {
      switch (_showtype) {
      case 0:
        sb.append("<input type=\"hidden\"  id=\"" + htmlobjname + "\" " + fieldNameHtml + "  name=\"" + htmlobjname + "\" value=\"" + _value + "\" >");
        break;
      case 1:
        sb.append("<input type=\"hidden\"  id=\"" + htmlobjname + "\" " + fieldNameHtml + "  name=\"" + htmlobjname + "\" value=\"" + _value + "\" >");
        sb.append("<span " + _style + " id=\"" + htmlobjname + "span\" " + fieldNameSpanHtml + "  name=\"" + htmlobjname + "span\" >");
        sb.append(_value);
        sb.append("</span>");
      }
    }
    else if (_htmltype.equals("4")) {
      String checked = "";
      if (_value.equals("1"))
        checked = " checked ";
      String defaultchecked = "";
      if (_defaultvalue.equals("1"))
        defaultchecked = " checked ";
      switch (_showtype) {
      case 0:
        sb.append("<input type=\"hidden\" " + fieldNameHtml + "  name=\"" + htmlobjname + "\"   id=\"" + htmlobjname + "\" value=\"" + _value + "\" >");
        break;
      case 1:
        sb.append("<input type=\"hidden\" " + fieldNameHtml + "  name=\"" + htmlobjname + "\"   id=\"" + htmlobjname + "\" value=\"" + _value + "\" >");
        if (isview.equals("1")) {
          sb.append("<span id=\"" + htmlobjname + "span\" " + fieldNameSpanHtml + "  name=\"" + htmlobjname + "span\" " + _style + "  >");

          if (_value.equals("1"))
            sb.append("<img src=\"" + BaseContext.getContextpath() + "/images/base/bacocheck.gif\" border=0>");
          else
            sb.append("<img src=\"" + BaseContext.getContextpath() + "/images/base/bacocross.gif\" border=0>");
          sb.append("</span>");
        } else {
          sb.append("<input type=\"checkbox\"  " + fieldNameHtml + "  disabled class=\"InputStyle2\" value=\"1\" name=\"" + htmlobjname + "\" " + checked + "   >");
        }
        break;
      }
    }
    else if (_htmltype.equals("8")) {
      sb.append("<input type='hidden' " + fieldNameHtml + " id='field_" + htmlobjname + "' name='field_" + htmlobjname + "' value=" + _value + " >");

      List list = selectitemService.getSelectitemList(_fieldtype, null);
      switch (_showtype) {
      case 0:
        break;
      case 1:
        for (int i = 0; i < list.size(); i++) {
          Selectitem boxItem = (Selectitem)list.get(i);

          String boxName = labelCustomService.getLabelNameBySelectitemForCurrentLanguage(boxItem);
          String boxValue = boxItem.getId();
          if (_value.indexOf(boxValue) > -1)
            sb.append("<img src='/images/base/bacocheck.gif' align='absmiddle'>");
          else {
            sb.append("<img src='/images/base/bacocross.gif' align='absmiddle'>");
          }
          sb.append("<span style='padding:0 10 0 2;'>" + boxName + "</span>");
        }
      }
    }
    else if (_htmltype.equals("5")) {
      if ((_htmltype.equals("5")) && ((_showtype == 2) || (_showtype == 3))) {
        sb.append("<input type=\"hidden\" name=\"field_" + _fieldname + "_fieldcheck\" value=\"" + _fieldcheck + "\" >");
      }
      if ("0".equals(_fieldtype)) {
        _fieldtype = "";
      }
      switch (_showtype) {
      case 0:
        sb.append("<input type=\"hidden\" " + fieldNameHtml + " name=\"" + htmlobjname + "\" id=\"" + htmlobjname + "\" value=\"" + _value + "\" >");
        break;
      case 1:
        String _showname = "";
        Selectitem _selectitem1 = selectitemService.getSelectitemById(_value);
        _showname = labelCustomService.getLabelNameBySelectitemForCurrentLanguage(_selectitem1);
        sb.append("<input type=\"hidden\" " + fieldNameHtml + "  name=\"" + htmlobjname + "\" id=\"" + htmlobjname + "\" value=\"" + _value + "\" >");

        sb.append("<span id=\"" + htmlobjname + "span\" " + fieldNameSpanHtml + "  name=\"" + htmlobjname + "span\" " + _style + "  >");
        sb.append(_showname);
        sb.append("</span>");
      }
    }
    else if (_htmltype.equals("6")) {
      Refobj refobj = this.refobjService.getRefobj(_fieldtype);
      if (refobj != null) {
        String _refid = StringHelper.null2String(refobj.getId());
        String _viewurl = StringHelper.null2String(refobj.getViewurl());
        String _reftable = StringHelper.null2String(refobj.getReftable());
        String _keyfield = StringHelper.null2String(refobj.getKeyfield());
        String _viewfield = StringHelper.null2String(refobj.getViewfield());
        String _selfield = StringHelper.null2String(refobj.getSelfield());
        _selfield = StringHelper.getEncodeStr(_selfield);
        String showname = "";
        String sql = "";
        if (!StringHelper.isEmpty(_value)) {
          sql = "select " + _keyfield + " as objid," + _viewfield + " as objname from " + _reftable + " where " + _keyfield + " in(" + StringHelper.formatMutiIDs(_value) + ")";
        }

        if (!StringHelper.isEmpty(sql)) {
          List valuelist = this.baseJdbcDao.executeSqlForList(sql);
          for (int i = 0; i < valuelist.size(); i++) {
            Map refmap = (Map)valuelist.get(i);
            String _objid = StringHelper.null2String((String)refmap.get("objid"));
            String _objname = StringHelper.null2String((String)refmap.get("objname")).replace(" ", "&nbsp;");

            if (!StringHelper.isEmpty(_viewurl)) {
              showname = showname + "<a style='color: blue;' href=javascript:onUrl('" + _viewurl + _objid + "','" + _objname + "','tab" + _objid + "') >";
            }
            showname = showname + "&nbsp;" + _objname + "&nbsp;";
            if (!StringHelper.isEmpty(_viewurl))
              showname = showname + "</a>";
            if ("humres".equals(_reftable)) {
              showname = showname + humresService.getRTXHtml(_objid);
            }
          }
        }
        switch (_showtype) {
        case 0:
          sb.append("<input type=\"hidden\" " + fieldNameHtml + "  name=\"" + htmlobjname + "\"   id=\"" + htmlobjname + "\"  value=\"" + _value + "\" >");

          break;
        case 1:
          sb.append("<input type=\"hidden\" " + fieldNameHtml + "  name=\"" + htmlobjname + "\"   id=\"" + htmlobjname + "\"  value=\"" + _value + "\" >");

          sb.append("<span id=\"" + htmlobjname + "span\" " + fieldNameSpanHtml + "  name=\"" + htmlobjname + "span\" " + _style + "  >");

          if (_refid.equals("402881e60bfee880010bff17101a000c")) {
            OrgunitService orgunitService = (OrgunitService)BaseContext.getBean("orgunitService");
            String[] orgids = _value.split(",");
            for (String orgid : orgids)
              sb.append(orgunitService.getOrgunitPathExceptRoot(orgid));
          }
          else {
            sb.append(showname);
          }
          sb.append("</span>");
        }
      }
    }
    else if (_htmltype.equals("7")) {
      switch (_showtype) {
      case 0:
        sb.append("<input type=\"hidden\" " + fieldNameHtml + "  name=\"" + htmlobjname + "\" id=\"" + htmlobjname + "\" value=\"" + _value + "\"  " + _style + " >");

        break;
      case 1:
        sb.append("<input type=\"hidden\" " + fieldNameHtml + "  name=\"field_" + htmlobjname + "\" value=\"" + _value + "\" >");
        if (!StringHelper.isEmpty(_value)) {
          String[] attachIds = _value.split(",");
          String batchDowloadHtml = attachIds.length > 1 ? this.formService.getBatchDowloadHtml(formfield, _value) : "";
          int nIndex = 1;
          for (String attachId : attachIds) {
            Attach attach = attachService.getAttach(attachId);
            String attachname = StringHelper.null2String(attach.getObjname());
            if (htmlobjname.equals("imgfile")) {
              sb.append("<img src=\"" + BaseContext.getContextpath() + "/ServiceAction/com.eweaver.document.file.FileDownload?attachid=" + attachId + "&download=1&nIndex=" + nIndex++ + "\" border=0 " + _style + " ><br/>");
            }
            else
            {
              if (attach.isApplication()) {
                sb.append("<a style='color: blue;' href=\"" + BaseContext.getContextpath() + "/ServiceAction/com.eweaver.document.file.FileDownload?attachid=" + attachId + "&isdownload=1&nIndex=" + nIndex++ + "\">" + attachname + " </a>&nbsp;&nbsp;&nbsp;");
              }
              else
              {
                sb.append("<a style='color: blue;' href=\"javascript:onUrl('" + BaseContext.getContextpath() + "/ServiceAction/com.eweaver.document.file.FileDownload?attachid=" + attachId + "&from=formservice&nIndex=" + nIndex + "','附件-" + attachname + "','" + attachname + "')\">" + attachname + "</a>&nbsp;&nbsp;&nbsp;");
              }

              sb.append("<a style='color: blue;' href=\"" + BaseContext.getContextpath() + "/ServiceAction/com.eweaver.document.file.FileDownload?attachid=" + attachId + "&isdownload=1&nIndex=" + nIndex++ + "\">下载 </a>");

              sb.append(batchDowloadHtml);
              sb.append("<br/>");

              batchDowloadHtml = "";
            }
          }
        }
        break;
      }
    }
    return sb.toString();
  }

  public String getCoworkNavigation(String tagid, String type, String searchtype, String searchobjname, int pageNo, int pageSize, String orderparam) {
    String formid = StringHelper.null2String(this.coworkset.getFormid());
    String formobjname = this.ds.getValue("SELECT objtablename FROM forminfo WHERE ID='" + formid + "' AND objtype ='0' AND isdelete=0");
    String coworktypefield = this.ds.getValue("SELECT fieldname FROM formfield WHERE ID='" + this.coworkset.getCoworktype() + "'");
    String title = StringHelper.null2String(this.coworkset.getSubject());
    String titleobjname = this.ds.getValue("SELECT fieldname FROM formfield WHERE ID='" + title + "' AND isdelete=0");
    String coworkmarkfield = this.ds.getValue("SELECT fieldname FROM formfield WHERE ID='" + this.coworkset.getCoworkremark() + "'");
    StringBuffer sqlwhere = new StringBuffer();
    if (!"".equals(tagid)) {
      if ((!tagid.equals("402881e83abf0214013abf0220810290")) && (!tagid.equals("402881e83abf0214013abf0220810291"))) {
        sqlwhere.append(" and requestid in (select requestid from coworktaglink where tagid ='" + tagid + "' and userid='" + this.eu.getId() + "' ) ");
      }
      if (tagid.equals("402881e83abf0214013abf0220810291")) {
        sqlwhere.append(getUnreadids());
      }
    }
    if (!tagid.equals("402881e83abf0214013abf0220810293")) {
      sqlwhere.append(" and requestid not in (select requestid from coworktaglink where tagid ='402881e83abf0214013abf0220810293' and userid='" + this.eu.getId() + "' ) ");
    }
    if (!"".equals(type)) {
      sqlwhere.append(getMyCoworkids(type));
    }
    if ((!"".equals(searchtype)) && (!"0".equals(searchtype))) {
      sqlwhere.append(" and " + coworktypefield + "='" + searchtype + "' ");
    }
    if (!"".equals(searchobjname)) {
      sqlwhere.append(" and " + titleobjname + " like '%" + searchobjname + "%' ");
    }
    if ("4".equals(type))
      sqlwhere.append(" and requestid in (select id from COWORKBASE where isdelete=0 and isclose=1) ");
    else {
      sqlwhere.append(" and requestid in (select id from COWORKBASE where isdelete=0 and isclose=0) ");
    }
    if ("1".equals(SQLMap.getDbtype()))
      sqlwhere.append(" and requestid in (select requestid from  coworkrule where begindate+' '+begintime < '" + DateHelper.getCurDateTime() + "')");
    else {
      sqlwhere.append(" and requestid in (select requestid from  coworkrule where begindate||' '||begintime < '" + DateHelper.getCurDateTime() + "')");
    }
    sqlwhere.append(" and requestid in (select requestid from COWORKRULE where isdelete=0) ");
    sqlwhere.append(" " + getStopCoworkids() + " ");
    String ordersql = "";
    if ("1".equals(SQLMap.getDbtype())) {
      if ("unimportant".equals(orderparam))
        ordersql = " ORDER BY (SELECT COUNT(*) FROM COWORKLOG  WHERE COWORKID = V.requestid AND ISDELETE = 0 AND operatetype!=3 and operatetype!=6 AND OPERATOR != '" + this.eu.getId() + "' AND OPERATEDATE+' '+SUBSTRING(OPERATETIME,len('0'+OPERATETIME)-7,len('0'+OPERATETIME)) > (isnull((SELECT MAX(OPERATEDATE+' '+SUBSTRING(OPERATETIME,len('0'+OPERATETIME)-7,len('0'+OPERATETIME))) FROM coworklog WHERE coworkid=V.requestid AND isdelete =0 and OPERATOR='" + this.eu.getId() + "'),'1970-01-01 00:00:00'))) DESC,v.id desc ";
      else if ("important".equals(orderparam))
        ordersql = " order by (isnull((select max(ordernum2) from COWORKTAG where ID in ( SELECT tagid FROM coworktaglink WHERE requestid =v.requestid and userid='" + this.eu.getId() + "')),0)) desc,v.id desc ";
      else {
        ordersql = ordersql + " order by (SELECT max(operatedate+' '+operatetime) FROM coworklog WHERE coworkid=v.requestid and operatetype!=3 and operatetype!=6) desc,v.id desc";
      }
    }
    else if ("unimportant".equals(orderparam))
      ordersql = " ORDER BY (SELECT COUNT(*) FROM COWORKLOG  WHERE COWORKID = V.requestid AND ISDELETE = 0 AND operatetype!=3 and operatetype!=6 AND OPERATOR != '" + this.eu.getId() + "' AND TO_DATE(OPERATEDATE||' '||TO_CHAR(TO_DATE(OPERATETIME, 'HH24:mi:ss'), 'HH24:mi:ss'),'yyyy-MM-dd HH24:mi:ss') > TO_DATE(nvl((SELECT MAX(operatedate||' '||operatetime) FROM coworklog WHERE coworkid=V.requestid AND isdelete =0 and OPERATOR='" + this.eu.getId() + "'),'1970-01-01 00:00:00'),'yyyy-MM-dd HH24:mi:ss')) DESC,v.id desc ";
    else if ("important".equals(orderparam))
      ordersql = " order by (nvl((select max(ordernum2) from COWORKTAG where ID in ( SELECT tagid FROM coworktaglink WHERE requestid =v.requestid and userid='" + this.eu.getId() + "')),0)) desc,v.id desc ";
    else {
      ordersql = ordersql + " order by (SELECT max(operatedate||' '||operatetime) FROM coworklog WHERE coworkid=v.requestid and operatetype!=3 and operatetype!=6) desc,v.id desc ";
    }

    String sql = "SELECT v.* FROM " + formobjname + " v where 1=1 " + sqlwhere + ordersql;

    Page reportpage = this.ds.pagedQuery(sql.toLowerCase(), pageNo, pageSize);
    List list = new ArrayList();
    int total = reportpage.getTotalSize();
    if (total > 0) {
      list = (List)reportpage.getResult();
    }
    StringBuffer coworkhtml = new StringBuffer("");
    StringBuffer tablehtml = new StringBuffer("");
    int i = 0;
    for (Map map : list) {
      String requestid_ = StringHelper.null2String(map.get("requestid"));

      List setlist = this.ds.getValues("select * from coworkrule where requestid='" + requestid_ + "' and isdelete=0");
      int isshowunread = 0;
      int isshowreply = 0;
      if ((setlist != null) && (setlist.size() > 0)) {
        Map setMap = (Map)setlist.get(0);
        isshowunread = NumberHelper.string2Int(setMap.get("isshowunread"), 0);
        isshowreply = NumberHelper.string2Int(setMap.get("isshowreply"), 0);
      }

      String titlestr = StringHelper.null2String(map.get(titleobjname.toLowerCase()));
      String tipimg = "";
      String tipstr = "";
      int replynum = 0;
      if (isshowreply == 0) {
        replynum = getReplyNum(requestid_);
        if (replynum > 0)
        {
          tipstr = tipstr + "<font class=tipfont>被回复(" + replynum + ")</font>，";
        }
      }
      int iReply = getSumReply(requestid_);
      if (iReply == 1)
        tipimg = iReply + " msg";
      else if (iReply > 1) {
        tipimg = iReply + " msgs";
      }
      if (isshowunread == 0) {
        int unreadnum = getUnreadNum(requestid_);
        if (unreadnum > 0) {
          tipstr = tipstr + "<font class=tipfont>新发表(" + (unreadnum - replynum) + ")</font>";

          tipimg = "<table class='unread' tipstr='" + tipstr + "'><tr><td class='unreadLeft'></td><td class='unreadCenter'>" + unreadnum + "</td><td class='unreadRight'></td></tr></table>of&nbsp;" + iReply + "";
        }
      }

      String subject = "<a href=\"javascript:readCowork('" + requestid_ + "');\" >" + titlestr + "</a>";
      if (titlestr.length() <= 22) {
        subject = "<a href=\"javascript:readCowork('" + requestid_ + "');\" >" + titlestr + "</a>";
      } else {
        titlestr = titlestr.substring(0, 22) + "...";
        subject = "<a href=\"javascript:readCowork('" + requestid_ + "');\" >" + titlestr + "</a>";
      }
      String coworkremark = Html2Text(StringHelper.null2String(map.get(coworkmarkfield)));
      if (coworkremark.length() > 24) {
        coworkremark = coworkremark.substring(0, 24) + "...";
      }
      subject = subject + "<br/><font class=\"remark\">" + coworkremark + "</font>";

      int c = NumberHelper.string2Int(this.ds.getValue("select count(*) from COWORKTAGLINK where requestid='" + requestid_ + "' and userid='" + this.eu.getId() + "' and tagid='402881e83abf0214013abf0220810292' "), 0);
      String tagimg = "";
      if (c > 0)
        tagimg = "<a href=\"javascript:onChangTag('" + requestid_ + "','no_402881e83abf0214013abf0220810292');\" ><img style=\"vertical-align: middle;\" src=\"/app/cooperation/images/importent.gif\" border=\"0\"/></a>";
      else {
        tagimg = "<a href=\"javascript:onChangTag('" + requestid_ + "','yes_402881e83abf0214013abf0220810292');\" ><img style=\"vertical-align: middle;\" src=\"/app/cooperation/images/notimportent.gif\" border=\"0\"/></a>";
      }
      String divclass = "itemgcolor1";
      if (i % 2 == 0) {
        divclass = "";
      }
      Map lastpMap = getLastReply(requestid_);
      tablehtml = new StringBuffer("<div class=\"item masonry_brick " + divclass + "\"><div class=\"d0\"><input type=\"checkbox\" value=\"" + requestid_ + "\" id=\"cbox_" + requestid_ + "\" name=\"cowork_cbox\" style=';'></div>" + "<div class=\"title d2\" id=\"" + requestid_ + "_title\" onclick=\"javascript:readCowork('" + requestid_ + "');\">" + subject + "</div><div class=\"d1\" id=\"" + requestid_ + "_tagimg\">" + tagimg + "</div><div class=\"d4\" >" + StringHelper.null2String((String)lastpMap.get(CoworkHelper.getParams("replydate"))).replace("-", "/") + "</div><div id=\"" + requestid_ + "_tipimg\" class=\"d3\">" + tipimg + "</div></div>");

      coworkhtml.append(tablehtml);
      i++;
    }
    return coworkhtml.toString();
  }

  public String getAllUnreadJson(String userid, String tagid, String type, String searchtype, String searchobjname, int pageNo, int pageSize, String orderparam) {
    String formid = StringHelper.null2String(this.coworkset.getFormid());
    String formobjname = this.ds.getValue("SELECT objtablename FROM forminfo WHERE ID='" + formid + "' AND objtype ='0' AND isdelete=0");
    StringBuffer sqlwhere = new StringBuffer();
    if (!"".equals(tagid)) {
      if ((!tagid.equals("402881e83abf0214013abf0220810290")) && (!tagid.equals("402881e83abf0214013abf0220810291"))) {
        sqlwhere.append(" and requestid in (select requestid from coworktaglink where tagid ='" + tagid + "' and userid='" + userid + "' ) ");
      }
      if (tagid.equals("402881e83abf0214013abf0220810291")) {
        sqlwhere.append(getUnreadids());
      }
    }
    if (!tagid.equals("402881e83abf0214013abf0220810293")) {
      sqlwhere.append(" and requestid not in (select requestid from coworktaglink where tagid ='402881e83abf0214013abf0220810293' and userid='" + userid + "' ) ");
    }
    if (!"".equals(type)) {
      sqlwhere.append(getMyCoworkids(userid, type));
    }
    if ("4".equals(type))
      sqlwhere.append(" and requestid in (select id from COWORKBASE where isdelete=0 and isclose=1) ");
    else {
      sqlwhere.append(" and requestid in (select id from COWORKBASE where isdelete=0 and isclose=0) ");
    }
    if ("1".equals(SQLMap.getDbtype()))
      sqlwhere.append(" and requestid in (select requestid from  coworkrule where begindate+' '+begintime < '" + DateHelper.getCurDateTime() + "')");
    else {
      sqlwhere.append(" and requestid in (select requestid from  coworkrule where begindate||' '||begintime < '" + DateHelper.getCurDateTime() + "')");
    }
    sqlwhere.append(" and requestid in (select requestid from COWORKRULE where isdelete=0) ");
    sqlwhere.append(" " + getStopCoworkids(userid) + " ");

    String sql = "SELECT v.* FROM " + formobjname + " v where 1=1 " + sqlwhere;

    Page reportpage = this.ds.pagedQuery(sql.toLowerCase(), pageNo, pageSize);
    List list = new ArrayList();
    int total = reportpage.getTotalSize();
    if (total > 0) {
      list = (List)reportpage.getResult();
    }
    JSONArray jsonArray = new JSONArray();
    for (Map map : list) {
      JSONObject jsonObject = new JSONObject();
      String requestid_ = StringHelper.null2String(map.get("requestid"));
      int unreadnum = 0;

      unreadnum = getUnreadNum(userid, requestid_);
      jsonObject.put("unreadnum", Integer.valueOf(unreadnum));
      jsonObject.put("requestid", requestid_);
      jsonArray.add(jsonObject);
    }
    return jsonArray.toString();
  }

  public String getCoworkNavigationJson(String userid, String tagid, String type, String searchtype, String searchobjname, int pageNo, int pageSize, String orderparam) {
    String formid = StringHelper.null2String(this.coworkset.getFormid());
    String formobjname = this.ds.getValue("SELECT objtablename FROM forminfo WHERE ID='" + formid + "' AND objtype ='0' AND isdelete=0");
    String coworktypefield = this.ds.getValue("SELECT fieldname FROM formfield WHERE ID='" + this.coworkset.getCoworktype() + "'");
    String title = StringHelper.null2String(this.coworkset.getSubject());
    String titleobjname = this.ds.getValue("SELECT fieldname FROM formfield WHERE ID='" + title + "' AND isdelete=0");
    String coworkmarkfield = this.ds.getValue("SELECT fieldname FROM formfield WHERE ID='" + this.coworkset.getCoworkremark() + "'");
    StringBuffer sqlwhere = new StringBuffer();
    if (!"".equals(tagid)) {
      if ((!tagid.equals("402881e83abf0214013abf0220810290")) && (!tagid.equals("402881e83abf0214013abf0220810291"))) {
        sqlwhere.append(" and requestid in (select requestid from coworktaglink where tagid ='" + tagid + "' and userid='" + userid + "' ) ");
      }
      if (tagid.equals("402881e83abf0214013abf0220810291")) {
        sqlwhere.append(getUnreadids());
      }
    }
    if (!tagid.equals("402881e83abf0214013abf0220810293")) {
      sqlwhere.append(" and requestid not in (select requestid from coworktaglink where tagid ='402881e83abf0214013abf0220810293' and userid='" + userid + "' ) ");
    }
    if (!"".equals(type)) {
      sqlwhere.append(getMyCoworkids(userid, type));
    }
    if ((!"".equals(searchtype)) && (!"0".equals(searchtype))) {
      sqlwhere.append(" and " + coworktypefield + "='" + searchtype + "' ");
    }
    if (!"".equals(searchobjname)) {
      sqlwhere.append(" and " + titleobjname + " like '%" + searchobjname + "%' ");
    }
    if ("4".equals(type))
      sqlwhere.append(" and requestid in (select id from COWORKBASE where isdelete=0 and isclose=1) ");
    else {
      sqlwhere.append(" and requestid in (select id from COWORKBASE where isdelete=0 and isclose=0) ");
    }
    if ("1".equals(SQLMap.getDbtype()))
      sqlwhere.append(" and requestid in (select requestid from  coworkrule where begindate+' '+begintime < '" + DateHelper.getCurDateTime() + "')");
    else {
      sqlwhere.append(" and requestid in (select requestid from  coworkrule where begindate||' '||begintime < '" + DateHelper.getCurDateTime() + "')");
    }
    sqlwhere.append(" and requestid in (select requestid from COWORKRULE where isdelete=0) ");
    sqlwhere.append(" " + getStopCoworkids(userid) + " ");
    String ordersql = "";
    if ("1".equals(SQLMap.getDbtype())) {
      if ("unimportant".equals(orderparam))
        ordersql = " ORDER BY (SELECT COUNT(*) FROM COWORKLOG  WHERE COWORKID = V.requestid AND ISDELETE = 0 AND operatetype!=3 and operatetype!=6 AND OPERATOR != '" + userid + "' AND OPERATEDATE+' '+SUBSTRING(OPERATETIME,len('0'+OPERATETIME)-7,len('0'+OPERATETIME)) > (isnull((SELECT MAX(OPERATEDATE+' '+SUBSTRING(OPERATETIME,len('0'+OPERATETIME)-7,len('0'+OPERATETIME))) FROM coworklog WHERE coworkid=V.requestid AND isdelete =0 and OPERATOR='" + userid + "'),'1970-01-01 00:00:00'))) DESC,v.id desc ";
      else if ("important".equals(orderparam))
        ordersql = " order by (isnull((select max(ordernum2) from COWORKTAG where ID in ( SELECT tagid FROM coworktaglink WHERE requestid =v.requestid and userid='" + userid + "')),0)) desc,v.id desc ";
      else {
        ordersql = ordersql + " order by (SELECT max(operatedate+' '+operatetime) FROM coworklog WHERE coworkid=v.requestid and operatetype!=3 and operatetype!=6) desc,v.id desc";
      }
    }
    else if ("unimportant".equals(orderparam))
      ordersql = " ORDER BY (SELECT COUNT(*) FROM COWORKLOG  WHERE COWORKID = V.requestid AND ISDELETE = 0 AND operatetype!=3 and operatetype!=6 AND OPERATOR != '" + userid + "' AND TO_DATE(OPERATEDATE||' '||TO_CHAR(TO_DATE(OPERATETIME, 'HH24:mi:ss'), 'HH24:mi:ss'),'yyyy-MM-dd HH24:mi:ss') > TO_DATE(nvl((SELECT MAX(operatedate||' '||operatetime) FROM coworklog WHERE coworkid=V.requestid AND isdelete =0 and OPERATOR='" + userid + "'),'1970-01-01 00:00:00'),'yyyy-MM-dd HH24:mi:ss')) DESC,v.id desc ";
    else if ("important".equals(orderparam))
      ordersql = " order by (nvl((select max(ordernum2) from COWORKTAG where ID in ( SELECT tagid FROM coworktaglink WHERE requestid =v.requestid and userid='" + userid + "')),0)) desc,v.id desc ";
    else {
      ordersql = ordersql + " order by (SELECT max(operatedate||' '||operatetime) FROM coworklog WHERE coworkid=v.requestid and operatetype!=3 and operatetype!=6) desc,v.id desc ";
    }

    String sql = "SELECT v.* FROM " + formobjname + " v where 1=1 " + sqlwhere + ordersql;

    Page reportpage = this.ds.pagedQuery(sql.toLowerCase(), pageNo, pageSize);
    List list = new ArrayList();
    int total = reportpage.getTotalSize();
    if (total > 0) {
      list = (List)reportpage.getResult();
    }
    JSONArray jsonArray = new JSONArray();
    for (Map map : list) {
      JSONObject jsonObject = new JSONObject();
      String requestid_ = StringHelper.null2String(map.get("requestid"));
      int replynum = 0;
      int newPublish = 0;
      int unreadnum = 0;

      unreadnum = getUnreadNum(userid, requestid_);
      if (unreadnum > 0) {
        newPublish = unreadnum - replynum;

        List setlist = this.ds.getValues("select * from coworkrule where requestid='" + requestid_ + "' and isdelete=0");
        int isshowunread = 0;
        int isshowreply = 0;
        if ((setlist != null) && (setlist.size() > 0)) {
          Map setMap = (Map)setlist.get(0);
          isshowunread = NumberHelper.string2Int(setMap.get("isshowunread"), 0);
          isshowreply = NumberHelper.string2Int(setMap.get("isshowreply"), 0);
        }

        String titlestr = StringHelper.null2String(map.get(titleobjname.toLowerCase()));
        String tipimg = "";
        String tipstr = "";

        String subject = "";
        String requestid = requestid_;
        String coworkremark = "";
        String isimport = "0";
        if (isshowreply == 0) {
          replynum = getReplyNum(userid, requestid_);
        }
        int iReply = getSumReply(requestid_);
        if (iReply == 1)
          tipimg = iReply + " msg";
        else if (iReply > 1) {
          tipimg = iReply + " msgs";
        }

        subject = titlestr;
        if (titlestr.length() > 22) {
          subject = titlestr.substring(0, 22) + "...";
        }
        coworkremark = Html2Text(StringHelper.null2String(map.get(coworkmarkfield)));
        if (coworkremark.length() > 24) {
          coworkremark = coworkremark.substring(0, 24) + "...";
        }

        int c = NumberHelper.string2Int(this.ds.getValue("select count(*) from COWORKTAGLINK where requestid='" + requestid_ + "' and userid='" + userid + "' and tagid='402881e83abf0214013abf0220810292' "), 0);
        if (c > 0) {
          isimport = "1";
        }

        Map lastpMap = getLastReply(requestid_);
        String lastreplaydate = StringHelper.null2String((String)lastpMap.get(CoworkHelper.getParams("replydate"))).replace("-", "/");
        jsonObject.put("replynum", Integer.valueOf(replynum));
        jsonObject.put("requestid", requestid);
        jsonObject.put("newPublish", Integer.valueOf(newPublish));
        jsonObject.put("unreadnum", Integer.valueOf(unreadnum));
        jsonObject.put("subject", subject);
        jsonObject.put("coworkremark", coworkremark);
        jsonObject.put("isimport", isimport);
        jsonObject.put("lastreplaydate", lastreplaydate);
        jsonArray.add(jsonObject);
      }
    }
    return jsonArray.toString();
  }

  public Map<String, String> getLastReply(String requestid)
  {
    String sql = "select * from " + CoworkHelper.getParams("replyform") + " where requestid in (select id from coworkreplybase where isdelete=0 and pid='" + requestid + "') order by " + CoworkHelper.getParams("replydate") + " desc," + CoworkHelper.getParams("replytime") + " desc";
    List lastreply = this.baseJdbcDao.getJdbcTemplate().queryForList(sql);
    if ((lastreply != null) && (lastreply.size() > 0)) {
      return (Map)lastreply.get(0);
    }
    return new HashMap();
  }

  public int getSumReply(String requestid)
  {
    String sql = "SELECT count(*) FROM coworklog WHERE coworkid='" + requestid + "' AND isdelete =0  and  (operatetype=4 OR operatetype=5)";
    return this.baseJdbcDao.getJdbcTemplate().queryForInt(sql);
  }

  public static String Html2Text(String inputString)
  {
    String htmlStr = inputString;
    String textStr = "";
    try
    {
      String regEx_script = "<[\\s]*?script[^>]*?>[\\s\\S]*?<[\\s]*?\\/[\\s]*?script[\\s]*?>";
      String regEx_style = "<[\\s]*?style[^>]*?>[\\s\\S]*?<[\\s]*?\\/[\\s]*?style[\\s]*?>";
      String regEx_html = "<[^>]+>";

      Pattern p_script = Pattern.compile(regEx_script, 2);
      Matcher m_script = p_script.matcher(htmlStr);
      htmlStr = m_script.replaceAll("");

      Pattern p_style = Pattern.compile(regEx_style, 2);
      Matcher m_style = p_style.matcher(htmlStr);
      htmlStr = m_style.replaceAll("");

      Pattern p_html = Pattern.compile(regEx_html, 2);
      Matcher m_html = p_html.matcher(htmlStr);
      htmlStr = m_html.replaceAll("");

      textStr = htmlStr;
    } catch (Exception e) {
    }
    return textStr;
  }

  public List<Map<String, String>> getCoworkPortal(int pageNo, int pageSize, Map<String, String> pmap) {
    String tagid = StringHelper.null2String((String)pmap.get("tagid"));
    String type = StringHelper.null2String((String)pmap.get("type"));
    if (StringHelper.isEmpty(type)) {
      type = "1";
    }
    String searchtype = StringHelper.null2String((String)pmap.get("searchtype"));
    String searchobjname = StringHelper.null2String((String)pmap.get("searchobjname"));
    String orderparam = StringHelper.null2String((String)pmap.get("order"));
    String showunread = StringHelper.null2String((String)pmap.get("showunread"));
    String subhead = StringHelper.null2String((String)pmap.get("subhead"));
    String counttype = StringHelper.null2String((String)pmap.get("counttype"));
    String otherview = StringHelper.null2String((String)pmap.get("otherview"));

    List portal = new ArrayList();
    String formid = StringHelper.null2String(this.coworkset.getFormid());
    String formobjname = this.ds.getValue("SELECT objtablename FROM forminfo WHERE ID='" + formid + "' AND objtype ='0' AND isdelete=0");
    String coworktypefield = this.ds.getValue("SELECT fieldname FROM formfield WHERE ID='" + this.coworkset.getCoworktype() + "'");
    String title = StringHelper.null2String(this.coworkset.getSubject());
    String titleobjname = this.ds.getValue("SELECT fieldname FROM formfield WHERE ID='" + title + "' AND isdelete=0");
    String coworkmarkfield = this.ds.getValue("SELECT fieldname FROM formfield WHERE ID='" + this.coworkset.getCoworkremark() + "'");
    StringBuffer sqlwhere = new StringBuffer();
    if ("1".equals(counttype)) {
      tagid = "402881e83abf0214013abf0220810291";
    }
    if (!"".equals(tagid)) {
      if ((!tagid.equals("402881e83abf0214013abf0220810290")) && (!tagid.equals("402881e83abf0214013abf0220810291"))) {
        sqlwhere.append(" and requestid in (select requestid from coworktaglink where tagid ='" + tagid + "' and userid='" + this.eu.getId() + "' ) ");
      }
      if (tagid.equals("402881e83abf0214013abf0220810291")) {
        sqlwhere.append(getUnreadids());
      }
    }
    if (!tagid.equals("402881e83abf0214013abf0220810293")) {
      sqlwhere.append(" and requestid not in (select requestid from coworktaglink where tagid ='402881e83abf0214013abf0220810293' and userid='" + this.eu.getId() + "' ) ");
    }
    if (!"".equals(type)) {
      sqlwhere.append(getMyCoworkids(type));
    }
    if ((!"".equals(searchtype)) && (!"0".equals(searchtype))) {
      sqlwhere.append(" and " + coworktypefield + "='" + searchtype + "' ");
    }
    if (!"".equals(searchobjname)) {
      sqlwhere.append(" and " + titleobjname + " like '%" + searchobjname + "%' ");
    }
    sqlwhere.append(" and requestid in (select id from COWORKBASE where isdelete=0 and isclose=0) ");
    if ("1".equals(SQLMap.getDbtype()))
      sqlwhere.append(" and requestid in (select requestid from  coworkrule where begindate+' '+begintime < '" + DateHelper.getCurDateTime() + "')");
    else {
      sqlwhere.append(" and requestid in (select requestid from  coworkrule where begindate||' '||begintime < '" + DateHelper.getCurDateTime() + "')");
    }
    sqlwhere.append(" and requestid in (select requestid from COWORKRULE where isdelete=0) ");
    sqlwhere.append(" " + getStopCoworkids() + " ");
    String ordersql = "";
    if ("1".equals(SQLMap.getDbtype()))
    {
      ordersql = ordersql + " order by  (SELECT max(operatedate+' '+operatetime) FROM coworklog WHERE coworkid=v.requestid and operatetype!=3 and operatetype!=6) desc";
    }
    else
    {
      ordersql = ordersql + " order by (SELECT max(operatedate||' '||operatetime) FROM coworklog WHERE coworkid=v.requestid and operatetype!=3 and operatetype!=6) desc";
    }

    String sql = "SELECT v.* FROM " + formobjname + " v where 1=1 " + sqlwhere + ordersql;

    Page reportpage = this.ds.pagedQuery(sql.toLowerCase(), pageNo, pageSize);
    List list = new ArrayList();

    int total = reportpage.getTotalSize();
    if (total > 0) {
      list = (List)reportpage.getResult();
    }
    int i = 0;
    for (Map map : list) {
      String requestid_ = StringHelper.null2String(map.get("requestid"));
      String titlestr = StringHelper.null2String(map.get(titleobjname.toLowerCase()));
      String tipimg = "";
      String tipstr = "";
      int iReply = getSumReply(requestid_);
      if (iReply == 1)
        tipimg = iReply + " msg";
      else if (iReply > 1) {
        tipimg = iReply + " msgs";
      }
      int unreadnum = 0;
      if (showunread.equals("1")) {
        int replynum = getReplyNum(requestid_);
        if (replynum > 0) {
          tipstr = tipstr + "<font class=\"tipfont\">被回复(" + replynum + ")</font>，";
        }
        unreadnum = getUnreadNum(requestid_);
        if (unreadnum > 0) {
          tipstr = tipstr + "<font class=\"tipfont\">新发表(" + (unreadnum - replynum) + ")</font>";
          tipimg = "<table class=\"unread\" tipstr='" + tipstr + "'><tr><td class=\"unreadLeft\"></td><td class=\"unreadCenter\">" + unreadnum + "</td><td class=\"unreadRight\"></td></tr></table>of&nbsp;" + iReply + "";
        }
      }

      String subject = titlestr;
      String coworkremark = Html2Text(StringHelper.null2String(map.get(coworkmarkfield)));

      Map portalmap = new HashMap();
      portalmap.put("subject", subject);
      portalmap.put("requestid", requestid_);
      portalmap.put("tipimg", tipimg);
      Map lastreply = getLastReply(requestid_);
      if (subhead.equals("0")) {
        portalmap.put("coworkremark", coworkremark);
      } else {
        String img = "lb3.png";
        if (unreadnum > 0) {
          img = "lb2.png";
        }
        portalmap.put("lastcontent", "<img src=\"/app/cooperation/images/" + img + "\" width=\"16px\" height=\"16px\">&nbsp;" + Html2Text(StringHelper.null2String((String)lastreply.get(CoworkHelper.getParams("replycontent")))));
      }
      if (otherview.equals("0")) {
        if ((lastreply != null) && (lastreply.size() > 0)) {
          portalmap.put("id", StringHelper.null2String((String)lastreply.get(CoworkHelper.getParams("replymembers"))));
          portalmap.put("objname", StringHelper.null2String(this.ds.getValue("select objname from humres where id='" + (String)lastreply.get(CoworkHelper.getParams("replymembers")) + "'")));
        }
        else {
          Map olist = this.ds.getValuesForMap("SELECT operator,(SELECT objname FROM humres WHERE ID=OPERATOR) as objname FROM coworklog  WHERE coworkid='" + requestid_ + "' AND operatetype=1");
          portalmap.put("id", StringHelper.null2String((String)olist.get("operator")));
          portalmap.put("objname", StringHelper.null2String((String)olist.get("objname")));
        }
      } else {
        String lastreplydate = StringHelper.null2String((String)lastreply.get(CoworkHelper.getParams("replydate"))).replace("-", "/");
        if ("".equals(lastreplydate))
        {
          lastreplydate = this.ds.getValue("SELECT operatedate FROM coworklog  WHERE coworkid='" + requestid_ + "' AND operatetype=1");
          portalmap.put("lastdate", StringHelper.null2String(lastreplydate).replace("-", "/"));
        } else {
          portalmap.put("lastdate", lastreplydate);
        }
      }

      portalmap.put("total", total + "");
      portal.add(portalmap);
      i++;
    }
    return portal;
  }
}