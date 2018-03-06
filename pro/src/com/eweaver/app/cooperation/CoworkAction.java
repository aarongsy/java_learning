package com.eweaver.app.cooperation;

import com.eweaver.base.AbstractAction;
import com.eweaver.base.BaseContext;
import com.eweaver.base.DataService;
import com.eweaver.base.IDGernerator;
import com.eweaver.base.Page;
import com.eweaver.base.SQLMap;
import com.eweaver.base.label.service.LabelService;
import com.eweaver.base.security.service.acegi.EweaverUser;
import com.eweaver.base.util.DateHelper;
import com.eweaver.base.util.NumberHelper;
import com.eweaver.base.util.StringHelper;
import com.eweaver.cowork.model.Coworkset;
import com.eweaver.cowork.service.CoworksetService;
import com.eweaver.document.base.model.Attach;
import com.eweaver.document.base.service.AttachService;
import com.eweaver.document.file.FileUpload;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

public class CoworkAction
  implements AbstractAction
{
  protected final Log logger = LogFactory.getLog(getClass());
  private HttpServletRequest request;
  private HttpServletResponse response;
  private String action;
  private CoworksetService coworksetService;
  private EweaverUser eu = BaseContext.getRemoteUser();
  private CoWorkService coWorkService = new CoWorkService();
  private AttachService attachService;
  private LabelService labelService;

  public CoworkAction(HttpServletRequest request, HttpServletResponse response)
  {
    this.request = request;
    this.response = response;
    this.coworksetService = ((CoworksetService)BaseContext.getBean("coworksetService"));
    this.eu = BaseContext.getRemoteUser();
    this.attachService = ((AttachService)BaseContext.getBean("attachService"));
    this.labelService = ((LabelService)BaseContext.getBean("labelService"));
  }

  public void execute() throws IOException, ServletException {
    FileUpload fileUpload = new FileUpload(this.request);
    this.request = fileUpload.resolveMultipart();
    this.action = StringHelper.null2String(this.request.getParameter("action"));

    if (this.action.equals("transform")) {
      String id = StringHelper.null2String(this.request.getParameter("id"));
      String members = "";
      String enddate = "";
      String categoryid = "";
      String colorfield = "";
      String createlayout = StringHelper.null2String(this.request.getParameter("createlayout"));
      String editlayout = StringHelper.null2String(this.request.getParameter("editlayout"));
      String viewlayout = StringHelper.null2String(this.request.getParameter("viewlayout"));
      String coworktype = StringHelper.null2String(this.request.getParameter("coworktype"));
      String replyformid = StringHelper.null2String(this.request.getParameter("replyformid"));
      String replycontent = StringHelper.null2String(this.request.getParameter("replycontent"));
      String replymembers = StringHelper.null2String(this.request.getParameter("replymembers"));
      String replydate = StringHelper.null2String(this.request.getParameter("replydate"));
      String replytime = StringHelper.null2String(this.request.getParameter("replytime"));
      String coworkremark = StringHelper.null2String(this.request.getParameter("coworkremark"));
      String attachtype = StringHelper.null2String(this.request.getParameter("attachtype"));
      String formid = StringHelper.null2String(this.request.getParameter("formid"));
      String objname = StringHelper.null2String(this.request.getParameter("objname"));
      String subject = StringHelper.null2String(this.request.getParameter("subject"));
      String description = StringHelper.null2String(this.request.getParameter("description"));
      String functionary = StringHelper.null2String(this.request.getParameter("functionary"));
      int showunread = NumberHelper.string2Int(this.request.getParameter("showunread"), 0);
      int replynotify = NumberHelper.string2Int(this.request.getParameter("replynotify"), 0);
      String defshow1 = StringHelper.null2String(this.request.getParameter("defshow1"));
      String defshow2 = StringHelper.null2String(this.request.getParameter("defshow2"));

      Coworkset coworkset = new Coworkset();
      coworkset.setCreatelayout(createlayout);
      coworkset.setEditlayout(editlayout);
      coworkset.setViewlayout(viewlayout);
      coworkset.setCoworktype(coworktype);
      coworkset.setReplyformid(replyformid);
      coworkset.setReplycontent(replycontent);
      coworkset.setReplymembers(replymembers);
      coworkset.setReplydate(replydate);
      coworkset.setReplytime(replytime);
      coworkset.setCoworkremark(coworkremark);
      coworkset.setAttachtype(attachtype);
      coworkset.setFormid(formid);
      coworkset.setCategoryid(categoryid);
      coworkset.setMembers(members);
      coworkset.setEnddate(enddate);
      coworkset.setObjname(objname);
      coworkset.setSubject(subject);
      coworkset.setColorfield(colorfield);
      coworkset.setDescription(description);
      coworkset.setShowunread(Integer.valueOf(showunread));
      coworkset.setReplynotify(Integer.valueOf(replynotify));
      coworkset.setFunctionary(functionary);
      coworkset.setDefshow1(defshow1);
      coworkset.setDefshow2(defshow2);
      if (StringHelper.isEmpty(id)) {
        this.coworksetService.create(coworkset);
      } else {
        coworkset.setId(id);
        this.coworksetService.modify(coworkset);
      }

      CoworkHelper.resetCoWorkSet();
    }
    if ("changestatus".equals(this.action)) {
      String requestid = StringHelper.null2String(this.request.getParameter("requestid"));
      DataService dataservice = new DataService();
      dataservice.executeSql("update coworkbase set isclose=0-(isclose-1) where id='" + requestid + "'");

      dataservice.executeSql("insert into coworklog (id,deliverid,coworkid,operator,operatedate,operatetime,replyid,operatetype,isdelete) values ('" + IDGernerator.getUnquieID() + "','','" + requestid + "','" + this.eu.getId() + "','" + DateHelper.getCurrentDate() + "','" + DateHelper.getCurrentTime() + "','',2,0)");
    }

    if ("delcowork".equals(this.action)) {
      String requestid = StringHelper.null2String(this.request.getParameter("requestid"));
      DataService dataservice = new DataService();
      dataservice.executeSql("update coworkbase set isdelete=1 where id='" + requestid + "'");

      dataservice.executeSql("insert into coworklog (id,deliverid,coworkid,operator,operatedate,operatetime,replyid,operatetype,isdelete) values ('" + IDGernerator.getUnquieID() + "','','" + requestid + "','" + this.eu.getId() + "','" + DateHelper.getCurrentDate() + "','" + DateHelper.getCurrentTime() + "','',6,0)");
    }

    if ("savecowork".equals(this.action)) {
      Map parameters = new HashMap();
      ArrayList fileinputs = fileUpload.getFileInputNameList();
      ArrayList attachids = fileUpload.getAttachList();

      for (int i = 0; i < fileinputs.size(); i++) {
        String pName = (String)fileinputs.get(i);
        if (!StringHelper.isEmpty(pName)) {
          Attach attach = (Attach)attachids.get(i);
          this.attachService.createAttach(attach);
          parameters.put(pName, attach.getId());
        }
      }
      String attachIdsName = null;
      String attachIds = "";

      List attachFieldNameList = new ArrayList();
      for (Enumeration e = this.request.getParameterNames(); e.hasMoreElements(); ) {
        String pName = e.nextElement().toString().trim();
        String pValue = StringHelper.trimToNull(this.request.getParameter(pName));
        if (pName.startsWith("attachIds")) {
          attachIdsName = pName;
          attachIds = pValue;

          String newAttachIds = "";
          if (!StringHelper.isEmpty(attachIds)) {
            String[] arAttach = attachIds.split(",");
            String attach = null;
            for (String attachId : arAttach) {
              attach = this.request.getParameter("attach" + attachId);
              if (StringHelper.isEmpty(attach))
                this.attachService.deleteAttach(attachId);
              else {
                newAttachIds = newAttachIds + "," + attachId;
              }
            }
            if (!StringHelper.isEmpty(newAttachIds))
              newAttachIds = newAttachIds.substring(1);
            attachIdsName = attachIdsName.substring("attachIds".length());
          }
          attachFieldNameList.add("field_" + attachIdsName);
          parameters.put("field_" + attachIdsName, newAttachIds);
        }
        else if (!attachFieldNameList.contains(pName))
        {
          if (!StringHelper.isEmpty(pName)) {
            if ("$currenttime$".equals(pValue == null ? "" : pValue.trim())) {
              pValue = DateHelper.getCurrentTime();
            }
            parameters.put(pName, pValue);
          }
        }
      }
      String type = StringHelper.null2String(this.request.getParameter("type"));

      if (("createcowork".equals(type)) || ("updatecowork".equals(type)))
      {
        parameters = this.coWorkService.saveFormData(parameters);
        String requestid = (String)parameters.get("requestid");
        this.response.sendRedirect(this.request.getContextPath() + "/app/cooperation/createcowork.jsp?requestid=" + requestid + "&editmode=1&isshow=1");
      }
      return;
    }
    if ("replycowork".equals(this.action)) {
      String type = StringHelper.null2String(this.request.getParameter("type"));
      if ("deliver".equals(type))
      {
        Map parameters = new HashMap();
        ArrayList fileinputs = fileUpload.getFileInputNameList();
        ArrayList attachids = fileUpload.getAttachList();
        for (int i = 0; i < fileinputs.size(); i++) {
          String pName = (String)fileinputs.get(i);
          if (!StringHelper.isEmpty(pName)) {
            Attach attach = (Attach)attachids.get(i);
            this.attachService.createAttach(attach);
            parameters.put(pName, attach.getId());
          }
        }
        String attachIdsName = null;
        String attachIds = "";

        List attachFieldNameList = new ArrayList();
        for (Enumeration e = this.request.getParameterNames(); e.hasMoreElements(); ) {
          String pName = e.nextElement().toString().trim();
          String pValue = StringHelper.trimToNull(this.request.getParameter(pName));
          if (pName.startsWith("attachIds")) {
            attachIdsName = pName;
            attachIds = pValue;

            String newAttachIds = "";
            if (!StringHelper.isEmpty(attachIds)) {
              String[] arAttach = attachIds.split(",");
              String attach = null;
              for (String attachId : arAttach) {
                attach = this.request.getParameter("attach" + attachId);
                if (StringHelper.isEmpty(attach))
                  this.attachService.deleteAttach(attachId);
                else {
                  newAttachIds = newAttachIds + "," + attachId;
                }
              }
              if (!StringHelper.isEmpty(newAttachIds))
                newAttachIds = newAttachIds.substring(1);
              attachIdsName = attachIdsName.substring("attachIds".length());
            }
            attachFieldNameList.add("field_" + attachIdsName);
            parameters.put("field_" + attachIdsName, newAttachIds);
          }
          else if (!attachFieldNameList.contains(pName))
          {
            if (!StringHelper.isEmpty(pName)) {
              if ("$currenttime$".equals(pValue == null ? "" : pValue.trim())) {
                pValue = DateHelper.getCurrentTime();
              }
              parameters.put(pName, pValue);
            }
          }
        }
        DataService ds = new DataService();
        Coworkset coworkset = CoworkHelper.getCoworkset();
        parameters.put("field_" + coworkset.getReplydate(), DateHelper.getCurrentDate());
        parameters.put("field_" + coworkset.getReplytime(), DateHelper.getCurrentTime());
        parameters.put("operatetype", "reply");
        String coworkrequestid = StringHelper.null2String(this.request.getParameter("coworkrequestid"));
        parameters.put("coworkrequestid", coworkrequestid);
        parameters = this.coWorkService.saveFormData(parameters);
        String deliverid = (String)parameters.get("requestid");

        ds.executeSql("insert into coworklog (id,deliverid,coworkid,operator,operatedate,operatetime,replyid,operatetype,isdelete) values ('" + IDGernerator.getUnquieID() + "','" + deliverid + "','" + coworkrequestid + "','" + this.eu.getId() + "','" + DateHelper.getCurrentDate() + "','" + DateHelper.getCurrentTime() + "','',4,0)");

        this.response.sendRedirect(this.request.getContextPath() + "/app/cooperation/coworkview.jsp?id=" + coworkrequestid);
      } else if ("reply".equals(type))
      {
        DataService ds = new DataService();
        Coworkset coworkset = CoworkHelper.getCoworkset();
        String formobjname = StringHelper.null2String(ds.getValue("SELECT objtablename FROM forminfo WHERE ID='" + coworkset.getReplyformid() + "' AND objtype ='0' AND isdelete=0"));
        String operatedatefield = StringHelper.null2String(ds.getValue("SELECT fieldname FROM formfield WHERE ID='" + coworkset.getReplydate() + "'"));
        String operatetimefield = StringHelper.null2String(ds.getValue("SELECT fieldname FROM formfield WHERE ID='" + coworkset.getReplytime() + "'"));
        String replyuserfield = StringHelper.null2String(ds.getValue("SELECT fieldname FROM formfield WHERE ID='" + coworkset.getReplymembers() + "'"));
        String replyfield = StringHelper.null2String(ds.getValue("SELECT fieldname FROM formfield WHERE ID='" + coworkset.getReplycontent() + "'"));

        String requestid = StringHelper.null2String(this.request.getParameter("requestid"));
        String replyid = StringHelper.null2String(this.request.getParameter("replyid"));
        String replycontent = StringHelper.null2String(this.request.getParameter("reply_content"));

        String baseid = IDGernerator.getUnquieID();
        String opdate = DateHelper.getCurrentDate();
        String optime = DateHelper.getCurrentTime();
        String sql = "insert into " + formobjname + "(id,requestid," + operatedatefield + "," + operatetimefield + "," + replyuserfield + "," + replyfield + ") values ('" + IDGernerator.getUnquieID() + "','" + baseid + "','" + opdate + "','" + optime + "','" + this.eu.getId() + "','" + replycontent + "')";

        ds.executeSql(sql);

        int storey = NumberHelper.string2Int(ds.getValue("select count(*) from COWORKREPLYBASE where pid='" + requestid + "' and isdelete=0"), 0) + 1;
        ds.executeSql("insert into COWORKREPLYBASE (id,pid,operator,operatedate,operatetime,storey,isdelete) values ('" + baseid + "','" + requestid + "','" + this.eu.getId() + "','" + opdate + "','" + optime + "','" + storey + "',0)");

        ds.executeSql("insert into coworklog (id,deliverid,coworkid,operator,operatedate,operatetime,replyid,operatetype,isdelete) values ('" + IDGernerator.getUnquieID() + "','" + baseid + "','" + requestid + "','" + this.eu.getId() + "','" + DateHelper.getCurrentDate() + "','" + DateHelper.getCurrentTime() + "','" + replyid + "',5,0)");

        this.response.sendRedirect(this.request.getContextPath() + "/app/cooperation/reply/replycoworklist.jsp?requestid=" + requestid);
      }

    }

    if ("delreply".equals(this.action)) {
      String pid = StringHelper.null2String(this.request.getParameter("requestid"));
      String id = StringHelper.null2String(this.request.getParameter("replyid"));
      String sql = "UPDATE coworkreplybase SET isdelete=1 WHERE pid ='" + pid + "' AND ID='" + id + "'";
      DataService ds = new DataService();
      ds.executeSql(sql);
    }

    if ("saverule".equals(this.action)) {
      String id = StringHelper.null2String(this.request.getParameter("id"));
      String orgid = StringHelper.null2String(this.request.getParameter("orgid"));
      String requestid = StringHelper.null2String(this.request.getParameter("requestid"));
      String creator = StringHelper.null2String(this.request.getParameter("creator"));
      String createdate = StringHelper.null2String(this.request.getParameter("createdate"));
      String createtime = StringHelper.null2String(this.request.getParameter("createtime"));
      String coworklevel = StringHelper.null2String(this.request.getParameter("coworklevel"));
      String begindate = StringHelper.null2String(this.request.getParameter("begindate"));
      String begintime = StringHelper.null2String(this.request.getParameter("begintime"));
      String datetype = StringHelper.null2String(this.request.getParameter("datetype"));
      String enddate = StringHelper.null2String(this.request.getParameter("enddate"));
      String endtime = StringHelper.null2String(this.request.getParameter("endtime"));
      String isshowunread = StringHelper.null2String(this.request.getParameter("isshowunread"));
      String isreply = StringHelper.null2String(this.request.getParameter("isreply"));
      String isshowreply = StringHelper.null2String(this.request.getParameter("isshowreply"));
      String isquote = StringHelper.null2String(this.request.getParameter("isquote"));
      String isshowadd = StringHelper.null2String(this.request.getParameter("isshowadd"));
      String viewtype = StringHelper.null2String(this.request.getParameter("viewtype"));
      String showlayoutid = StringHelper.null2String(this.request.getParameter("showlayoutid"));
      String showaddlayout = StringHelper.null2String(this.request.getParameter("showaddlayout"));
      DataService dataservice = new DataService();
      String sql = "";
      if (StringHelper.isEmpty(id)) {
        id = IDGernerator.getUnquieID();
        sql = "insert into coworkrule (id,requestid,orgid,creator,createdate,createtime,coworklevel,begindate,begintime,datetype,enddate,endtime,isshowunread,isreply,isshowreply,isquote,isshowadd,viewtype,showlayoutid,showaddlayout,isdelete) values ('" + id + "','" + requestid + "','" + orgid + "','" + creator + "','" + createdate + "','" + createtime + "','" + coworklevel + "','" + begindate + "','" + begintime + "','" + datetype + "','" + enddate + "','" + endtime + "','" + isshowunread + "','" + isreply + "','" + isshowreply + "','" + isquote + "','" + isshowadd + "','" + viewtype + "','" + showlayoutid + "','" + showaddlayout + "',0)";
      }
      else
      {
        sql = "update coworkrule set  coworklevel='" + coworklevel + "',begindate='" + begindate + "',begintime='" + begintime + "',datetype='" + datetype + "',enddate='" + enddate + "',endtime='" + endtime + "'," + "isshowunread='" + isshowunread + "',isreply='" + isreply + "',isshowreply='" + isshowreply + "',isquote='" + isquote + "',isshowadd='" + isshowadd + "',viewtype='" + viewtype + "',showlayoutid='" + showlayoutid + "',showaddlayout='" + showaddlayout + "' " + " where id='" + id + "' and requestid='" + requestid + "'";
      }

      dataservice.executeSql(sql);
    }

    if ("savepermission".equals(this.action)) {
      String id = StringHelper.null2String(this.request.getParameter("id"));
      String del = StringHelper.null2String(this.request.getParameter("del"));
      String requestid = StringHelper.null2String(this.request.getParameter("requestid"));
      String oprule = StringHelper.null2String(this.request.getParameter("oprule"));
      String opunit = StringHelper.null2String(this.request.getParameter("opunit"));
      String content = StringHelper.null2String(this.request.getParameter("content"));
      int minseclevel = NumberHelper.string2Int(this.request.getParameter("minseclevel"), -1);
      int maxseclevel = NumberHelper.string2Int(this.request.getParameter("maxseclevel"), -1);
      String sql = "delete from COWORKPERMISSION where requestid='" + requestid + "' and id='" + id + "'";
      DataService dataservice = new DataService();
      dataservice.executeSql(sql);
      if ("0".equals(del)) {
        id = IDGernerator.getUnquieID();
        if ((minseclevel >= 0) && (maxseclevel >= 0)) {
          sql = "insert into COWORKPERMISSION (id,requestid,oprule,opunit,content,minseclevel,maxseclevel,ISDELETE) values ('" + id + "','" + requestid + "','" + oprule + "','" + opunit + "','" + content + "','" + minseclevel + "','" + maxseclevel + "',0)";
        }
        else if ((minseclevel >= 0) && (maxseclevel < 0)) {
          sql = "insert into COWORKPERMISSION (id,requestid,oprule,opunit,content,minseclevel,ISDELETE) values ('" + id + "','" + requestid + "','" + oprule + "','" + opunit + "','" + content + "','" + minseclevel + "',0)";
        }
        else if ((minseclevel < 0) && (maxseclevel >= 0)) {
          sql = "insert into COWORKPERMISSION (id,requestid,oprule,opunit,content,maxseclevel,ISDELETE) values ('" + id + "','" + requestid + "','" + oprule + "','" + opunit + "','" + content + "','" + maxseclevel + "',0)";
        }
        else {
          sql = "insert into COWORKPERMISSION (id,requestid,oprule,opunit,content,ISDELETE) values ('" + id + "','" + requestid + "','" + oprule + "','" + opunit + "','" + content + "',0)";
        }

        dataservice.executeSql(sql);
        PrintWriter writer = this.response.getWriter();
        StringBuffer sb = new StringBuffer();
        sb.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
        sb.append("<msg>" + id + "</msg>");
        this.response.setContentType("text/xml;charset=UTF-8");
        writer.print(sb.toString());
        writer.flush();
      } else {
        PrintWriter writer = this.response.getWriter();
        StringBuffer sb = new StringBuffer();
        sb.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
        sb.append("<msg></msg>");
        this.response.setContentType("text/xml;charset=UTF-8");
        writer.print(sb.toString());
        writer.flush();
      }
    }
    if ("delpermission".equals(this.action)) {
      String requestid = StringHelper.null2String(this.request.getParameter("requestid"));
      String sql = "delete from COWORKPERMISSION where requestid='" + requestid + "'";
      DataService dataservice = new DataService();
      dataservice.executeSql(sql);
    }

    if ("saveaddfun".equals(this.action)) {
      String id = StringHelper.null2String(this.request.getParameter("id"));
      String del = StringHelper.null2String(this.request.getParameter("del"));
      String requestid = StringHelper.null2String(this.request.getParameter("requestid"));
      String fieldid = StringHelper.null2String(this.request.getParameter("fieldid"));
      String fieldname = StringHelper.null2String(this.request.getParameter("fieldname"));
      int ordernum = NumberHelper.string2Int(this.request.getParameter("ordernum"), -1);
      String orderfield = StringHelper.null2String(this.request.getParameter("orderfield"));
      String sql = "delete from coworkaddfun where requestid='" + requestid + "' and id='" + id + "'";
      DataService dataservice = new DataService();
      dataservice.executeSql(sql);
      if ("0".equals(del)) {
        id = IDGernerator.getUnquieID();
        if (ordernum >= 0) {
          sql = "insert into coworkaddfun (id,requestid,fieldid,fieldname,ordernum,orderfield,ISDELETE) values ('" + id + "','" + requestid + "','" + fieldid + "','" + fieldname + "','" + ordernum + "','" + orderfield + "',0)";
        }
        else {
          sql = "insert into coworkaddfun (id,requestid,fieldid,fieldname,orderfield,ISDELETE) values ('" + id + "','" + requestid + "','" + fieldid + "','" + fieldname + "','" + orderfield + "',0)";
        }

        dataservice.executeSql(sql);
        PrintWriter writer = this.response.getWriter();
        StringBuffer sb = new StringBuffer();
        sb.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
        sb.append("<msg>" + id + "</msg>");
        this.response.setContentType("text/xml;charset=UTF-8");
        writer.print(sb.toString());
        writer.flush();
      } else {
        PrintWriter writer = this.response.getWriter();
        StringBuffer sb = new StringBuffer();
        sb.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
        sb.append("<msg></msg>");
        this.response.setContentType("text/xml;charset=UTF-8");
        writer.print(sb.toString());
        writer.flush();
      }
    }
    if ("deladdfun".equals(this.action)) {
      String requestid = StringHelper.null2String(this.request.getParameter("requestid"));
      String sql = "delete from coworkaddfun where requestid='" + requestid + "'";
      DataService dataservice = new DataService();
      dataservice.executeSql(sql);
    }

    if ("savetag".equals(this.action)) {
      String id = StringHelper.null2String(this.request.getParameter("id"));
      String del = StringHelper.null2String(this.request.getParameter("del"));
      String objname = StringHelper.null2String(this.request.getParameter("objname"));
      String ordernum = StringHelper.null2String(this.request.getParameter("ordernum"));
      ordernum = "".equals(ordernum) ? "0" : ordernum;
      String disabled = StringHelper.null2String(this.request.getParameter("disabled"));
      if (("402881e83abf0214013abf0220810290".equals(id)) || ("402881e83abf0214013abf0220810291".equals(id)) || ("402881e83abf0214013abf0220810292".equals(id)) || ("402881e83abf0214013abf0220810293".equals(id))) {
        PrintWriter writer = this.response.getWriter();
        StringBuffer sb = new StringBuffer();
        sb.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
        sb.append("<msg>" + id + "</msg>");
        this.response.setContentType("text/xml;charset=UTF-8");
        writer.print(sb.toString());
        writer.flush();
        return;
      }
      DataService dataservice = new DataService();
      String sql = "";
      if (StringHelper.isEmpty(dataservice.getValue("select id from coworktag where id='" + id + "' and userid='" + this.eu.getId() + "'"))) {
        id = IDGernerator.getUnquieID();
        sql = "insert into COWORKTAG (id,objname,ordernum,disabled,userid,ISDELETE) values ('" + id + "','" + objname + "','" + ordernum + "','" + disabled + "','" + this.eu.getId() + "',0)";
        dataservice.executeSql(sql);
      } else {
        sql = "update coworktag set objname='" + objname + "',ordernum='" + ordernum + "',disabled='" + disabled + "' where id='" + id + "' and userid='" + this.eu.getId() + "'";
        dataservice.executeSql(sql);
      }
      if ("0".equals(del)) {
        PrintWriter writer = this.response.getWriter();
        StringBuffer sb = new StringBuffer();
        sb.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
        sb.append("<msg>" + id + "</msg>");
        this.response.setContentType("text/xml;charset=UTF-8");
        writer.print(sb.toString());
        writer.flush();
      } else {
        sql = "delete from COWORKTAG  where id='" + id + "' and id not in ('402881e83abf0214013abf0220810290','402881e83abf0214013abf0220810291','402881e83abf0214013abf0220810292','402881e83abf0214013abf0220810293') and userid ='" + this.eu.getId() + "'";
        dataservice.executeSql(sql);
        PrintWriter writer = this.response.getWriter();
        StringBuffer sb = new StringBuffer();
        sb.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
        sb.append("<msg> </msg>");
        this.response.setContentType("text/xml;charset=UTF-8");
        writer.print(sb.toString());
        writer.flush();
      }

    }

    if ("getcoworklist".equals(this.action)) {
      queryCoWorkList();
    }

    if ("getcoworkreport".equals(this.action)) {
      queryCoWorkReport();
    }

    if (("changeCoWorkTag".equals(this.action)) || ("readCoWork".equals(this.action)) || ("batchChangeCoWorkTag".equals(this.action))) {
      String requestid = StringHelper.null2String(this.request.getParameter("requestid"));
      String tagid = StringHelper.null2String(this.request.getParameter("tagid"));
      DataService dataservice = new DataService();
      if (tagid.indexOf("no_") > -1) {
        if (tagid.equals("no_402881e83abf0214013abf0220810291"))
        {
          dataservice.executeSql("insert into coworklog (id,deliverid,coworkid,operator,operatedate,operatetime,replyid,operatetype,isdelete) values ('" + IDGernerator.getUnquieID() + "','','" + requestid + "','" + this.eu.getId() + "','" + DateHelper.getCurrentDate() + "','" + DateHelper.getCurrentTime() + "','',3,0)");
        }

        String sql = "DELETE  FROM coworktaglink WHERE requestid='" + requestid + "' and tagid='" + tagid.substring(3) + "' and userid='" + this.eu.getId() + "'";
        dataservice.executeSql(sql);
      } else if (tagid.indexOf("yes_") > -1) {
        int c = NumberHelper.string2Int(dataservice.getValue("select count(*) from COWORKTAGLINK where requestid ='" + requestid + "' and userid='" + this.eu.getId() + "' and tagid='" + tagid.substring(4) + "'"));
        if (c <= 0) {
          dataservice.executeSql("insert into COWORKTAGLINK (id,requestid,tagid,isdelete,userid) values ('" + IDGernerator.getUnquieID() + "','" + requestid + "','" + tagid.substring(4) + "',0,'" + this.eu.getId() + "')");
        }
      }
      if (!"batchChangeCoWorkTag".equals(this.action)) {
        Coworkset coworkset = CoworkHelper.getCoworkset();
        if (("".equals(coworkset)) || (coworkset == null)) {
          return;
        }
        String titleobjname = dataservice.getValue("SELECT fieldname FROM formfield WHERE ID='" + coworkset.getSubject() + "' AND isdelete=0");
        String formobjname = dataservice.getValue("SELECT objtablename FROM forminfo WHERE ID='" + coworkset.getFormid() + "' AND objtype ='0' AND isdelete=0");
        String coworkmarkfield = dataservice.getValue("SELECT fieldname FROM formfield WHERE ID='" + coworkset.getCoworkremark() + "'");
        String sql = "SELECT * FROM " + formobjname + " v where requestid='" + requestid + "'";
        List list = dataservice.getValues(sql);
        String cellHtml = "";
        int i = 0;
        for (Map map : list) {
          String requestid_ = StringHelper.null2String(map.get("requestid"));

          List setlist = dataservice.getValues("select * from coworkrule where requestid='" + requestid_ + "' and isdelete=0");
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
            replynum = this.coWorkService.getReplyNum(requestid_);
            if (replynum > 0)
            {
              tipstr = tipstr + "<font class=tipfont>被回复(" + replynum + ")</font>，";
            }
          }
          int iReply = this.coWorkService.getSumReply(requestid_);
          if (iReply == 1)
            tipimg = iReply + " msg";
          else if (iReply > 1) {
            tipimg = iReply + " msgs";
          }
          if (isshowunread == 0) {
            int unreadnum = this.coWorkService.getUnreadNum(requestid_);
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
          String coworkremark = CoWorkService.Html2Text(StringHelper.null2String(map.get(coworkmarkfield)));
          if (coworkremark.length() > 24) {
            coworkremark = coworkremark.substring(0, 24) + "...";
          }
          subject = subject + "<br/><font class=\"remark\">" + coworkremark + "</font>";

          int c = NumberHelper.string2Int(dataservice.getValue("select count(*) from COWORKTAGLINK where requestid='" + requestid_ + "' and userid='" + this.eu.getId() + "' and tagid='402881e83abf0214013abf0220810292' "), 0);
          String tagimg = "";
          if (c > 0)
            tagimg = "<a href=\"javascript:onChangTag('" + requestid_ + "','no_402881e83abf0214013abf0220810292');\" ><img style=\"vertical-align: middle;\" src=\"/app/cooperation/images/importent.gif\" border=\"0\"/></a>";
          else {
            tagimg = "<a href=\"javascript:onChangTag('" + requestid_ + "','yes_402881e83abf0214013abf0220810292');\" ><img style=\"vertical-align: middle;\" src=\"/app/cooperation/images/notimportent.gif\" border=\"0\"/></a>";
          }
          String divclass = "itemgcolor1";
          if (i % 2 != 0) {
            divclass = "";
          }
          if ("changeCoWorkTag".equals(this.action))
            cellHtml = tagimg;
          else {
            cellHtml = tipimg;
          }
          i++;
        }
        PrintWriter writer = this.response.getWriter();
        StringBuffer sb = new StringBuffer();
        sb.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
        sb.append("<cell><![CDATA[" + cellHtml + "]]></cell>");
        this.response.setContentType("text/xml;charset=UTF-8");
        writer.print(sb.toString());
        writer.flush();
      }
      return;
    }

    if ("coworkmenu".equals(this.action)) {
      DataService ds = new DataService();
      StringBuffer menu = new StringBuffer("[");
      menu.append("{id:\"allcbox_useless\",text:\" \",width:\"0px\",height:\"21px\"},");

      menu.append("{id: \"coworktype\", text:\"协作类型\"},");
      menu.append("{id:\"402881e83abf0214013abf0220810290\", text:\"全部协作\", pid: \"coworktype\"},");
      menu.append("{id:\"402881e83abf0214013abf0220810291\", text:\"未读协作\", pid: \"coworktype\"},");
      menu.append("{id:\"402881e83abf0214013abf0220810292\", text:\"重要协作\", pid: \"coworktype\"},");
      menu.append("{id:\"402881e83abf0214013abf0220810293\", text:\"隐藏协作\", pid: \"coworktype\"},");
      List list = ds.getValues("select * from COWORKTAG where disabled='0' and (userid='" + this.eu.getId() + "' or userid is null) " + "and id not in ('402881e83abf0214013abf0220810290','402881e83abf0214013abf0220810291','402881e83abf0214013abf0220810292','402881e83abf0214013abf0220810293') and ISDELETE=0 order by ordernum asc");

      if ((list != null) && (list.size() > 0)) {
        menu.append("{id:\"othercowork\", text:\"自定义协作\", pid: \"coworktype\"},");
        for (Map m : list) {
          String id = StringHelper.null2String(m.get("id"));
          String objname = StringHelper.null2String(m.get("objname"));
          menu.append("{id:\"" + id + "\", text:\"" + objname + "\", pid: \"othercowork\"},");
        }
      }

      menu.append("{id: \"order\", text:\"排序\"},");

      menu.append("{id: \"important\", text: \"按重要排序\", pid: \"order\"},");
      menu.append("{id: \"unread\", text: \"按未读排序\", pid: \"order\"},");
      menu.append("{id: \"tag\", text: \"标记\"},");

      menu.append("{id: \"no_402881e83abf0214013abf0220810291\", text: \"标记已读\", pid: \"tag\"},");
      menu.append("{id: \"yes_402881e83abf0214013abf0220810292\", text: \"标记重要\", pid: \"tag\"},");
      menu.append("{id: \"no_402881e83abf0214013abf0220810292\", text: \"取消重要 \", pid: \"tag\"},");
      menu.append("{id: \"yes_402881e83abf0214013abf0220810293\", text: \"标记隐藏\", pid: \"tag\"},");
      menu.append("{id: \"no_402881e83abf0214013abf0220810293\", text: \"取消隐藏\", pid: \"tag\"},");
      if ((list != null) && (list.size() > 0)) {
        menu.append("{id: \"othertag\", text: \"自定义标记\", pid: \"tag\"},");
        for (Map m : list) {
          String id = StringHelper.null2String(m.get("id"));
          String objname = StringHelper.null2String(m.get("objname"));
          menu.append("{id: \"yes_" + id + "\", text: \"标记" + objname + "\", pid: \"othertag\"},");
          menu.append("{id: \"no_" + id + "\", text: \"取消" + objname + "\", pid: \"othertag\"},");
        }
      }
      menu.append("{id:\"tagmanager\", text: \"标签管理\", iconCls:\"miniui-menu-icon-tag\"}");
      menu.append("]");
      PrintWriter writer = this.response.getWriter();
      writer.print(menu.toString());
      writer.flush();
      return;
    }

    if ("replymenu".equals(this.action)) {
      String requestid = StringHelper.null2String(this.request.getParameter("requestid"));
      StringBuffer menu = new StringBuffer("[{id:\"replypage1\", text: \"相关交流\"},");

      menu.append("{id:\"replypage2\", text: \"参与情况\"},");

      menu.append("{id: \"replypage2_1\", text: \"参与条件\", pid: \"replypage2\"},");
      menu.append("{id: \"replypage2_2\", text: \"参与人员\", pid: \"replypage2\"},");
      Coworkset coworkset = CoworkHelper.getCoworkset();
      int unreador = coworkset.getShowunread().intValue();
      if (unreador == 1) {
        menu.append("{id: \"replypage2_3\", text: \"未查看者\", pid: \"replypage2\"},");
      }
      DataService ds = new DataService();
      int showaddfun = NumberHelper.string2Int(ds.getValue("select isshowadd from COWORKRULE where isdelete=0 and requestid='" + requestid + "'"), 0);
      List l = ds.getValues("select id,fieldid,fieldname from COWORKADDFUN where requestid='" + requestid + "' and isdelete=0 order by ordernum asc");
      if ((l != null) && (l.size() > 0) && 
        (showaddfun == 0)) {
        menu.append("{id: \"replypage3\", text:\"相关信息\"},");

        for (Map m : l) {
          String fieldid = StringHelper.null2String((String)m.get("id"));
          String fieldname = StringHelper.null2String((String)m.get("fieldname"));
          if (StringHelper.isEmpty(fieldname)) {
            fieldname = ds.getValue("SELECT labelname FROM formfield WHERE ID='" + fieldid + "'");
          }
          menu.append("{id: \"replypage3_" + fieldid + "\", text: \"" + fieldname + "\", pid: \"replypage3\"},");
        }

      }

      menu.append("{id: \"readlog\", text: \"查看日志\"},");
      menu.append("{id: \"searchreply\", text: \"快捷搜索\", iconCls:\"miniui-menu-icon-search\"}");
      menu.append("]");
      PrintWriter writer = this.response.getWriter();
      writer.print(menu.toString());
      writer.flush();
      return;
    }
  }

  private void queryCoWorkReport() {
    EweaverUser user = BaseContext.getRemoteUser();
    if (user == null)
      return;
    PrintWriter out = null;
    try {
      out = this.response.getWriter();
    } catch (IOException e) {
      e.printStackTrace();
    }
    DataService dataService = new DataService();
    Coworkset coworkset = CoworkHelper.getCoworkset();
    String formid = "";
    String formobjname = "";
    String title = "";
    String titleobjname = "";
    if ((coworkset != null) && (coworkset.getId() != null) && (!"".equals(coworkset.getId()))) {
      formid = StringHelper.null2String(coworkset.getFormid());
      title = StringHelper.null2String(coworkset.getSubject());
      titleobjname = dataService.getValue("SELECT fieldname FROM formfield WHERE ID='" + title + "' AND isdelete=0");
      formobjname = dataService.getValue("SELECT objtablename FROM forminfo WHERE ID='" + formid + "' AND objtype ='0' AND isdelete=0");
    } else {
      out.print("<h5><img src='/images/base/icon_nopermit.gif' align='absmiddle' />请联系管理员！先设置好协作区关联表单信息后再来操作。</h5>");
      return;
    }

    String coworkname = StringHelper.null2String(this.request.getParameter("coworkname"));
    StringBuffer sqlwhere = new StringBuffer();
    sqlwhere.append(this.coWorkService.getMyCoworkids("3"));
    sqlwhere.append(" and requestid in (select id from COWORKBASE where isdelete=0) ");
    if (!StringHelper.isEmpty(coworkname)) {
      sqlwhere.append(" and " + titleobjname + " like '%" + coworkname + "%'");
    }
    sqlwhere.append(" " + this.coWorkService.getStopCoworkids() + " ");
    String sql = "SELECT v.* FROM " + formobjname + " v where 1=1 ";
    sql = sql + sqlwhere;
    sql = sql + " order by id asc ";

    int start = NumberHelper.string2Int(this.request.getParameter("start"), 0);
    int limit = NumberHelper.string2Int(this.request.getParameter("limit"), 25) + start;
    int pageSize = limit - start;
    int pageNo = limit % pageSize > 0 ? limit / pageSize + 1 : limit / pageSize;
    Page reportpage = dataService.pagedQuery(sql.toLowerCase(), pageNo, pageSize);
    List list = new ArrayList();
    int total = reportpage.getTotalSize();
    if (total > 0) {
      list = (List)reportpage.getResult();
    }
    JSONArray jsonArray = new JSONArray();
    for (Map map : list) {
      JSONObject o = new JSONObject();
      String requestid_ = StringHelper.null2String(map.get("requestid"));
      o.put("id", requestid_);
      String titlestr = StringHelper.null2String(map.get(titleobjname));
      if (titlestr.length() > 50) {
        titlestr = titlestr.substring(0, 50) + "...";
      }

      String subject = "<a href=\"javascript:onUrl('/app/cooperation/createcowork.jsp?requestid=" + requestid_ + "&editmode=1&isshow=1','" + StringHelper.convertToUnicode(titlestr) + "','tab" + requestid_ + "');\" >" + titlestr + "</a>";
      o.put("objname", subject);
      String createdate = StringHelper.null2String(dataService.getValue("select createdate from COWORKBASE where id='" + requestid_ + "'"));
      String createtime = StringHelper.null2String(dataService.getValue("select createtime from COWORKBASE where id='" + requestid_ + "'"));
      o.put("createdate", createdate);
      o.put("createtime", createtime);
      String status = StringHelper.null2String(dataService.getValue("select isclose from COWORKBASE where id='" + requestid_ + "'"));
      o.put("status", status.equals("0") ? "正常" : "已关闭");
      String temp = status.equals("0") ? "关闭" : "重新打开";
      String lastcol = "<a href=\"javascript:checkType('" + requestid_ + "');\">" + temp + "</a>&nbsp;";
      String creator = StringHelper.null2String(dataService.getValue("select creator from COWORKBASE where id='" + requestid_ + "'"));
      if (this.eu.getId().equals(creator)) {
        lastcol = lastcol + "/&nbsp;<a href=\"javascript:delCowork('" + requestid_ + "');\">删除</a>";
      }
      o.put("lastcol", lastcol);
      jsonArray.add(o);
    }
    JSONObject jsonObject = new JSONObject();
    jsonObject.put("totalProperty", Integer.valueOf(total));
    jsonObject.put("root", jsonArray);
    out.print(jsonObject);
  }

  private void queryCoWorkList() {
    EweaverUser user = BaseContext.getRemoteUser();
    if (user == null)
      return;
    PrintWriter out = null;
    try {
      out = this.response.getWriter();
    } catch (IOException e) {
      e.printStackTrace();
    }
    DataService dataService = new DataService();
    Coworkset coworkset = CoworkHelper.getCoworkset();
    if (("".equals(coworkset)) || (coworkset == null)) {
      return;
    }
    String formid = "";
    String formobjname = "";
    String title = "";
    String titleobjname = "";
    String coworktypefield = "";
    String coworkmarkfield = "";
    if ((coworkset != null) && (!"".equals(coworkset.getId()))) {
      formid = StringHelper.null2String(coworkset.getFormid());
      title = StringHelper.null2String(coworkset.getSubject());
      titleobjname = dataService.getValue("SELECT fieldname FROM formfield WHERE ID='" + title + "' AND isdelete=0");
      formobjname = dataService.getValue("SELECT objtablename FROM forminfo WHERE ID='" + formid + "' AND objtype ='0' AND isdelete=0");
      coworktypefield = dataService.getValue("SELECT fieldname FROM formfield WHERE ID='" + coworkset.getCoworktype() + "'");
      coworkmarkfield = dataService.getValue("SELECT fieldname FROM formfield WHERE ID='" + coworkset.getCoworkremark() + "'");
    } else {
      out.print("<h5><img src='/images/base/icon_nopermit.gif' align='absmiddle' />请联系管理员！先设置好协作区关联表单信息后再来操作。</h5>");
      return;
    }

    int pageSize = NumberHelper.string2Int(StringHelper.null2String(this.request.getParameter("pagesize")), 15);
    int pageNo = NumberHelper.string2Int(StringHelper.null2String(this.request.getParameter("page")), 2);

    String type = StringHelper.null2String(this.request.getParameter("type"));
    String tagid = StringHelper.null2String(this.request.getParameter("tagid"));
    String searchtype = StringHelper.null2String(this.request.getParameter("searchtype"));
    String searchobjname = StringHelper.null2String(this.request.getParameter("searchobjname"));
    String orderparam = StringHelper.null2String(this.request.getParameter("order"));
    StringBuffer sqlwhere = new StringBuffer();
    if (!"".equals(tagid)) {
      if ((!tagid.equals("402881e83abf0214013abf0220810290")) && (!tagid.equals("402881e83abf0214013abf0220810291"))) {
        sqlwhere.append(" and requestid in (select requestid from coworktaglink where tagid ='" + tagid + "' and userid='" + this.eu.getId() + "' ) ");
      }
      if (tagid.equals("402881e83abf0214013abf0220810291")) {
        sqlwhere.append(this.coWorkService.getUnreadids());
      }
    }
    if (!tagid.equals("402881e83abf0214013abf0220810293")) {
      sqlwhere.append(" and requestid not in (select requestid from coworktaglink where tagid ='402881e83abf0214013abf0220810293' and userid='" + this.eu.getId() + "' ) ");
    }
    if (!"".equals(type)) {
      sqlwhere.append(this.coWorkService.getMyCoworkids(type));
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
      sqlwhere.append(" and requestid in (select requestid from  coworkrule where begindate+' '+begintime < '" + DateHelper.getCurDateTime() + "') ");
    else {
      sqlwhere.append(" and requestid in (select requestid from  coworkrule where begindate||' '||begintime < '" + DateHelper.getCurDateTime() + "') ");
    }
    sqlwhere.append(" and requestid in (select requestid from COWORKRULE where isdelete=0) ");
    sqlwhere.append(" " + this.coWorkService.getStopCoworkids() + " ");
    String ordersql = "";
    if ("1".equals(SQLMap.getDbtype())) {
      if ("unimportant".equals(orderparam))
        ordersql = " ORDER BY (SELECT COUNT(*) FROM COWORKLOG  WHERE COWORKID = V.requestid AND ISDELETE = 0 AND operatetype!=3 and operatetype!=6 AND OPERATOR != '" + this.eu.getId() + "' AND OPERATEDATE+' '+SUBSTRING(OPERATETIME,len('0'+OPERATETIME)-7,len('0'+OPERATETIME)) > (isnull((SELECT MAX(OPERATEDATE+' '+SUBSTRING(OPERATETIME,len('0'+OPERATETIME)-7,len('0'+OPERATETIME))) FROM coworklog WHERE coworkid=V.requestid AND isdelete =0 and OPERATOR='" + this.eu.getId() + "'),'1970-01-01 00:00:00'))) DESC,v.id desc ";
      else if ("important".equals(orderparam))
        ordersql = " order by (isnull((select max(ordernum2) from COWORKTAG where ID in ( SELECT tagid FROM coworktaglink WHERE requestid =v.requestid and userid='" + this.eu.getId() + "')),0)) desc,v.id desc ";
      else {
        ordersql = ordersql + " order by (SELECT max(operatedate+' '+operatetime) FROM coworklog WHERE coworkid=v.requestid and operatetype!=3 and operatetype!=6) desc,v.id desc ";
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

    Page reportpage = dataService.pagedQuery(sql.toLowerCase(), pageNo, pageSize);
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

      List setlist = dataService.getValues("select * from coworkrule where requestid='" + requestid_ + "' and isdelete=0");
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
        replynum = this.coWorkService.getReplyNum(requestid_);
        if (replynum > 0)
        {
          tipstr = tipstr + "<font class=tipfont>被回复(" + replynum + ")</font>，";
        }
      }
      int iReply = this.coWorkService.getSumReply(requestid_);
      if (iReply == 1)
        tipimg = iReply + " msg";
      else if (iReply > 1) {
        tipimg = iReply + " msgs";
      }
      if (isshowunread == 0) {
        int unreadnum = this.coWorkService.getUnreadNum(requestid_);
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
      String coworkremark = CoWorkService.Html2Text(StringHelper.null2String(map.get(coworkmarkfield)));
      if (coworkremark.length() > 24) {
        coworkremark = coworkremark.substring(0, 24) + "...";
      }
      subject = subject + "<br/><font class=\"remark\">" + coworkremark + "</font>";

      int c = NumberHelper.string2Int(dataService.getValue("select count(*) from COWORKTAGLINK where requestid='" + requestid_ + "' and userid='" + this.eu.getId() + "' and tagid='402881e83abf0214013abf0220810292' "), 0);
      String tagimg = "";
      if (c > 0)
        tagimg = "<a href=\"javascript:onChangTag('" + requestid_ + "','no_402881e83abf0214013abf0220810292');\" ><img style=\"vertical-align: middle;\" src=\"/app/cooperation/images/importent.gif\" border=\"0\"/></a>";
      else {
        tagimg = "<a href=\"javascript:onChangTag('" + requestid_ + "','yes_402881e83abf0214013abf0220810292');\" ><img style=\"vertical-align: middle;\" src=\"/app/cooperation/images/notimportent.gif\" border=\"0\"/></a>";
      }
      String divclass = "itemgcolor1";
      if (i % 2 != 0) {
        divclass = "";
      }
      Map lastpMap = this.coWorkService.getLastReply(requestid_);
      String lastReplyDate = "";
      String tempData = StringHelper.null2String((String)lastpMap.get(CoworkHelper.getParams("replydate")));
      if ((tempData != null) && 
        (!"".equals(tempData.trim()))) {
        lastReplyDate = DateHelper.convertDateIntoDisplayStr(DateHelper.stringtoDate(tempData), "yyyy/MM/dd");
      }

      tablehtml = new StringBuffer("<div class=\"item masonry_brick " + divclass + "\"><div class=\"d0\"><input type=\"checkbox\" value=\"" + requestid_ + "\" id=\"cbox_" + requestid_ + "\" name=\"cowork_cbox\"></div>" + "<div class=\"title d2\" id=\"" + requestid_ + "_title\" onclick=\"javascript:readCowork('" + requestid_ + "');\">" + subject + "</div><div class=\"d1\" id=\"" + requestid_ + "_tagimg\">" + tagimg + "</div><div class=\"d4\">" + lastReplyDate + "</div><div id=\"" + requestid_ + "_tipimg\" class=\"d3\" >" + tipimg + "</div></div>");

      coworkhtml.append(tablehtml);
      i++;
    }
    out.print(coworkhtml);
  }
}