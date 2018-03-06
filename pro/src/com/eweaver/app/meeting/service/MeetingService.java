package com.eweaver.app.meeting.service;

import com.eweaver.base.BaseContext;
import com.eweaver.base.DataService;
import com.eweaver.base.IDGernerator;
import com.eweaver.base.security.service.acegi.EweaverUser;
import com.eweaver.base.security.util.PermissionTool;
import com.eweaver.base.util.DateHelper;
import com.eweaver.base.util.StringHelper;
import com.eweaver.humres.base.model.Humres;
import com.eweaver.workflow.form.model.FormBase;
import com.eweaver.workflow.form.service.FormBaseService;
import java.text.DateFormat;
import java.util.Date;
import java.util.Map;

public class MeetingService
{
  public void saveschdule(Map meetMap, String requestid)
  {
    String isadd = StringHelper.null2String(meetMap.get("isadd"));
    String mname = StringHelper.null2String(meetMap.get("mname"));
    String mtopic = StringHelper.null2String(meetMap.get("mtopic"));
    String msponsor = StringHelper.null2String(meetMap.get("msponsor"));
    String spondept = StringHelper.null2String(meetMap.get("spondept"));
    String spontime = StringHelper.null2String(meetMap.get("spontime"));
    String mbdate = StringHelper.null2String(meetMap.get("mbdate"));
    String medate = StringHelper.null2String(meetMap.get("medate"));
    String mloc = StringHelper.null2String(meetMap.get("mloc"));
    String richenshijian = StringHelper.null2String(meetMap.get("richenshijian"));
    String mlocrequestid = StringHelper.null2String(meetMap.get("mlocrequestid"));
    String iparticipant = StringHelper.null2String(meetMap.get("iparticipant"));
    String mcircle = StringHelper.null2String(meetMap.get("mcircle"));
    String leixing = StringHelper.null2String(meetMap.get("leixing"));
    String xingqi = StringHelper.null2String(meetMap.get("xingqi"));
    StringBuffer mainschdulesql = new StringBuffer();
    StringBuffer formbasesql = new StringBuffer();
    StringBuffer detailsql = new StringBuffer();

    mainschdulesql.append("insert into uf_schedule(id,requestid,tijiaoren,");
    mainschdulesql.append("tijiaobumen,tijiaoriqi,isdelete,richenshijian,");
    mainschdulesql.append("richengleixing,biaoti,jieshuriqi,gongzuoneirong,");
    mainschdulesql.append("laiyuan,meetingid,kaishiriqi,richengren,gsdidian)");

    detailsql.append("insert into uf_scheduledetail(id,requestid,shijian,didian,neirong,roomid,xingqi)");
    formbasesql.append("insert into formbase(id,creator,createdate,createtime,isdelete)");

    DataService dataService = new DataService();
    String relsoinid = IDGernerator.getUnquieID();

    formbasesql.append(" values('" + relsoinid + "','" + msponsor + "'").append(",");
    formbasesql.append("'" + DateHelper.getCurrentDate() + "'").append(",");
    formbasesql.append("'" + DateHelper.getCurrentTime() + "',0)");
    dataService.executeSql(formbasesql.toString());

    mainschdulesql.append(" values('" + IDGernerator.getUnquieID() + "'").append(",");
    mainschdulesql.append("'" + relsoinid + "','" + msponsor + "','" + spondept + "'").append(",");
    mainschdulesql.append("'" + spontime + "',0,'" + mbdate + "','" + leixing + "'");
    mainschdulesql.append(",'" + mname + "','" + medate + "','" + mtopic + "','meeting'").append(",");
    mainschdulesql.append("'" + requestid + "','" + mbdate + "','" + iparticipant + "','" + mloc + "')");

    dataService.executeSql(mainschdulesql.toString());

    if ("40288182306cae59013072625b240704".equals(leixing))
    {
      detailsql.append(" values('" + IDGernerator.getUnquieID() + "'").append(",");
      detailsql.append("'" + relsoinid + "','" + medate + "','" + mloc + "','" + mtopic + "','" + requestid + "',");
      detailsql.append("'星期" + xingqi + "'").append(")");
      dataService.executeSql(detailsql.toString());
    }
  }

  public void extract(Map meetMap, String requestid)
  {
    String iparticipant = StringHelper.null2String(meetMap.get("iparticipant"));
    if (!StringHelper.isEmpty(iparticipant))
      if (iparticipant.indexOf(",") > 0) {
        String[] perarray = iparticipant.split(",");
        for (int k = 0; k < perarray.length; k++)
        {
          String relse = IDGernerator.getUnquieID();
          meetMap.put("relse", relse);
          meetMap.put("iparticipant", perarray[k]);

          personalSchedule(meetMap, requestid);
        }
      }
      else {
        personalSchedule(meetMap, requestid);
      }
  }

  public void personalSchedule(Map meetMap, String requestid)
  {
    FormBaseService formBaseService = (FormBaseService)BaseContext.getBean("formbaseService");
    String isadd = StringHelper.null2String(meetMap.get("isadd"));
    String mname = StringHelper.null2String(meetMap.get("mname"));
    String mtopic = StringHelper.null2String(meetMap.get("mtopic"));
    String msponsor = StringHelper.null2String(meetMap.get("msponsor"));
    String spondept = StringHelper.null2String(meetMap.get("spondept"));
    String spontime = StringHelper.null2String(meetMap.get("spontime"));
    String mbdate = StringHelper.null2String(meetMap.get("mbdate"));
    String medate = StringHelper.null2String(meetMap.get("medate"));
    String mloc = StringHelper.null2String(meetMap.get("mloc"));
    String richenshijian = StringHelper.null2String(meetMap.get("richenshijian"));
    String mlocrequestid = StringHelper.null2String(meetMap.get("mlocrequestid"));
    String iparticipant = StringHelper.null2String(meetMap.get("iparticipant"));
    String mcircle = StringHelper.null2String(meetMap.get("mcircle"));
    String leixing = StringHelper.null2String(meetMap.get("leixing"));
    String xingqi = StringHelper.null2String(meetMap.get("xingqi"));

    String categoryid = "402883c235efe4db0135f167f2ef001c";
    Humres currhumres = BaseContext.getRemoteUser().getHumres();
    FormBase formBase = new FormBase();

    formBase.setCreatedate(DateHelper.getCurrentDate());
    formBase.setCreatetime(DateHelper.getCurrentTime());
    formBase.setCreator(currhumres.getId());
    formBase.setCategoryid(categoryid);
    formBase.setIsdelete(Integer.valueOf(0));
    formBaseService.createFormBase(formBase);

    String sdate = "";
    String stime = "";
    String edate = "";
    String etime = "";
    if ((!StringHelper.isEmpty(mbdate)) && (mbdate.length() == 16)) {
      sdate = mbdate.substring(0, 10);
      stime = mbdate.substring(11) + ":00";
    }

    if ((!StringHelper.isEmpty(medate)) && (medate.length() == 16)) {
      edate = medate.substring(0, 10);
      etime = medate.substring(11) + ":00";
    }

    StringBuffer buffer = new StringBuffer(512);
    buffer.append("insert into uf_work_schedule(id,requestid,sdate,stime,content,colourlabel,title,edate,etime,founder,stype,sresource) values('");
    buffer.append(IDGernerator.getUnquieID()).append("',");
    buffer.append("'").append(formBase.getId()).append("',");
    buffer.append("'").append(sdate).append("',");
    buffer.append("'").append(stime).append("',");
    buffer.append("'").append(mtopic).append("',");
    buffer.append("'").append("402883c235efe4db0135f14c93800008").append("',");
    buffer.append("'").append(mname).append("',");
    buffer.append("'").append(edate).append("',");
    buffer.append("'").append(etime).append("',");
    buffer.append("'").append(StringHelper.null2String(iparticipant)).append("',");
    buffer.append("'").append("40288273372a162501372a8d541100c9").append("',");
    buffer.append("'").append("").append("')");
    DataService dataService = new DataService();
    dataService.executeSql(buffer.toString());
    PermissionTool permissionTool = new PermissionTool();
    permissionTool.addPermission(categoryid, formBase.getId(), "uf_work_schedule");
  }

  public void companySchedule(Map meetMap, String requestid) {
    FormBaseService formBaseService = (FormBaseService)BaseContext.getBean("formbaseService");
    String categoryid = "4028827337255f820137258299c1000c";
    Humres currhumres = BaseContext.getRemoteUser().getHumres();
    FormBase formBase = new FormBase();

    formBase.setCreatedate(DateHelper.getCurrentDate());
    formBase.setCreatetime(DateHelper.getCurrentTime());
    formBase.setCreator(StringHelper.null2String(currhumres.getId()));
    formBase.setCategoryid(categoryid);
    formBase.setIsdelete(Integer.valueOf(0));
    formBaseService.createFormBase(formBase);

    String isadd = StringHelper.null2String(meetMap.get("isadd"));
    String mname = StringHelper.null2String(meetMap.get("mname"));
    String mtopic = StringHelper.null2String(meetMap.get("mtopic"));
    String msponsor = StringHelper.null2String(meetMap.get("msponsor"));
    String spondept = StringHelper.null2String(meetMap.get("spondept"));
    String spontime = StringHelper.null2String(meetMap.get("spontime"));
    String mbdate = StringHelper.null2String(meetMap.get("mbdate"));
    String medate = StringHelper.null2String(meetMap.get("medate"));
    String mloc = StringHelper.null2String(meetMap.get("mloc"));
    String richenshijian = StringHelper.null2String(meetMap.get("richenshijian"));
    String mlocrequestid = StringHelper.null2String(meetMap.get("mlocrequestid"));
    String iparticipant = StringHelper.null2String(meetMap.get("iparticipant"));
    String mcircle = StringHelper.null2String(meetMap.get("mcircle"));
    String leixing = StringHelper.null2String(meetMap.get("leixing"));
    String xingqi = StringHelper.null2String(meetMap.get("xingqi"));
    String sdate = "";
    String stime = "";
    String edate = "";
    String etime = "";
    if ((!StringHelper.isEmpty(mbdate)) && (mbdate.length() == 16)) {
      sdate = mbdate.substring(0, 10);
      stime = mbdate.substring(11) + ":00";
    }

    if ((!StringHelper.isEmpty(medate)) && (medate.length() == 16)) {
      edate = medate.substring(0, 10);
      etime = medate.substring(11) + ":00";
    }

    StringBuffer buffer = new StringBuffer(512);
    buffer.append("insert into uf_schedule(id,requestid,biaoti,kaishiriqi,jieshuriqi,gsdidian,gongzuoneirong,tijiaoren,tijiaobumen,tijiaoriqi,richengleixing) values('");
    buffer.append(IDGernerator.getUnquieID()).append("',");
    buffer.append("'").append(formBase.getId()).append("',");
    buffer.append("'").append(mname).append("',");
    buffer.append("'").append(sdate).append("',");
    buffer.append("'").append(edate).append("',");
    buffer.append("'").append(mloc).append("',");
    buffer.append("'").append(mtopic).append("',");
    buffer.append("'").append(currhumres.getId()).append("',");
    buffer.append("'").append(currhumres.getOrgid()).append("',");
    buffer.append("'").append(DateHelper.getCurrentDate()).append("',");
    buffer.append("'").append("40288182306cae59013072625b240703").append("')");
    DataService dataService = new DataService();
    dataService.executeSql(buffer.toString());
    PermissionTool permissionTool = new PermissionTool();
    permissionTool.addPermission(categoryid, formBase.getId(), "uf_schedule");
  }

  public boolean isweek(String returnstartdate) {
    if ((DateHelper.getDayOfWeek(new Date(returnstartdate.replace("-", "/"))) == 7) || (DateHelper.getDayOfWeek(new Date(returnstartdate.replace("-", "/"))) == 1))
    {
      return true;
    }
    return false;
  }

  public void pubfun(Map meetMap, Map basedatemap)
  {
    String isadd = StringHelper.null2String(meetMap.get("isadd"));
    String requestid = StringHelper.null2String(meetMap.get("requestid"));
    String iparticipant = StringHelper.null2String(meetMap.get("iparticipant"));
    if (isadd.equals("1"))
    {
      meetMap.put("leixing", "40288182306cae59013072625b240703");
      companySchedule(meetMap, requestid);
      publishcompany(meetMap, basedatemap, requestid);
    } else if (!StringHelper.isEmpty(iparticipant)) {
      publishcompany(meetMap, basedatemap, requestid);
    }
  }

  public void publishcompany(Map meetMap, Map basedatemap, String requestid)
  {
    DateFormat dateFormat = DateFormat.getDateInstance();
    String mbdate = StringHelper.null2String(meetMap.get("mbdate"));
    String medate = StringHelper.null2String(meetMap.get("medate"));
    int isflag = Integer.parseInt(StringHelper.null2String(basedatemap.get("isflag")));
    long datelength = Long.parseLong(StringHelper.null2String(basedatemap.get("datelength")));

    for (int j = 0; j < datelength + 1L; j++) {
      String returnstartdate = DateHelper.dayMove(mbdate, j);
      if (!isweek(returnstartdate))
      {
        try
        {
          Date getDate = dateFormat.parse(returnstartdate);
          int dateval = DateHelper.getDayOfWeek(getDate);
          if (dateval == isflag) {
            meetMap.put("leixing", "40288182306cae59013072625b240704");
            meetMap.put("mbdate", returnstartdate + " " + mbdate.substring(11, 16));
            meetMap.put("medate", returnstartdate + " " + medate.substring(11, 16));
            extract(meetMap, requestid);
          }
        }
        catch (Exception e)
        {
        }
      }
    }
  }
}