package com.eweaver.app.sap.orgunit;

import com.eweaver.app.configsap.SapConnector;
import com.eweaver.base.BaseContext;
import com.eweaver.base.BaseJdbcDao;
import com.eweaver.base.IDGernerator;
import com.eweaver.base.orgunit.model.Orgunit;
import com.eweaver.base.orgunit.service.OrgunitService;
import com.eweaver.base.security.model.Sysuser;
import com.eweaver.base.security.service.acegi.EweaverUser;
import com.eweaver.base.security.service.logic.SysuserService;
import com.eweaver.base.security.util.PermissionTool;
import com.eweaver.base.util.DateHelper;
import com.eweaver.base.util.StringHelper;
import com.eweaver.humres.base.model.Humres;
import com.eweaver.humres.base.service.HumresService;
import com.eweaver.workflow.form.model.FormBase;
import com.eweaver.workflow.form.service.FormBaseService;
import com.sap.conn.jco.JCoFunction;
import com.sap.conn.jco.JCoParameterList;
import com.sap.conn.jco.JCoTable;
import java.io.PrintStream;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import org.apache.commons.lang.time.DateUtils;
import org.json.simple.JSONArray;

public class Humre_ZHR_ENTRY_INF_GET
{
  public String functionname;
  private OrgunitService orgService;
  private HumresService hrService;
  private SysuserService suService;
  private BaseJdbcDao baseJdbc;

  public Humre_ZHR_ENTRY_INF_GET(String functionname)
  {
    setFunctionname(functionname);
  }

  public JCoTable findData(String usrid) {
    return findData(usrid, usrid);
  }

  public JCoTable findData(String usrid_low, String usrid_high) {
    try {
      String errorMessage = "";
      SapConnector sapConnector = new SapConnector();
      String functionName = "ZHR_ENTRY_INF_GET";
      JCoFunction function = SapConnector.getRfcFunction(functionName);
      if (function == null) {
        System.out.println(functionName + " not found in SAP.");
        System.out.println("SAP_RFC中没有此函数!");
        errorMessage = functionName + " not found in SAP.";
      }

      function.getImportParameterList().setValue("USRID_LOW", usrid_low);
      function.getImportParameterList().setValue("USRID_HIGH", usrid_high);

      function.execute(
        SapConnector.getDestination("sanpowersap"));
      JCoParameterList returnStructure = function.getTableParameterList();
      return function.getTableParameterList().getTable("EEINF");
    } catch (Exception e) {
      e.printStackTrace();
    }

    return null;
  }
  public JCoTable findData2(String date_low, String date_high) {
    try {
      String errorMessage = "";
      SapConnector sapConnector = new SapConnector();
      String functionName = "ZHR_ENTRY_INF_GETX";
      JCoFunction function = SapConnector.getRfcFunction(functionName);
      if (function == null) {
        System.out.println(functionName + " not found in SAP.");
        System.out.println("SAP_RFC中没有此函数!");
        errorMessage = functionName + " not found in SAP.";
      }

      function.getImportParameterList().setValue("BEGDA", dateValue(date_low));
      function.getImportParameterList().setValue("ENDDA", dateValue(date_high));

      function.execute(
        SapConnector.getDestination("sanpowersap"));
      JCoParameterList returnStructure = function.getTableParameterList();
      return function.getTableParameterList().getTable("EEINF");
    } catch (Exception e) {
      e.printStackTrace();
    }

    return null;
  }
  public String dateValue(String ovalue) {
    if ((ovalue.length() == 10) && (ovalue.indexOf("-") == 4) && (ovalue.lastIndexOf("-") == 7))
      ovalue = ovalue.replaceAll("-", "");
    else if ((ovalue.length() == 7) && (ovalue.indexOf("-") == 4))
      ovalue = ovalue.replaceAll("-", "");
    else if ((ovalue.length() == 8) && (ovalue.indexOf(":") == 2) && (ovalue.indexOf(":") == 5)) {
      ovalue = ovalue.replaceAll(":", "");
    }
    return ovalue;
  }

  public void syncHumre(String hid) throws ParseException {
    String userId = BaseContext.getRemoteUser().getId();
    this.orgService = ((OrgunitService)BaseContext.getBean("orgunitService"));
    this.hrService = ((HumresService)BaseContext.getBean("humresService"));
    Humre_ZHR_ENTRY_INF_GET app = new Humre_ZHR_ENTRY_INF_GET(
      "ZHR_STRUC_GET");
    JCoTable hrTable = app.findData(hid);

    JSONArray array = new JSONArray();
    if (hrTable != null)
      for (int i = 0; i < hrTable.getNumRows(); i++) {
        boolean exist = true;
        String pernr = StringHelper.null2String(hrTable.getString("PERNR"));
        Humres humre = this.hrService.findHumreBySap(pernr);
        if (humre == null) {
          humre = new Humres();
          exist = false;
        }
        humre.setExttextfield15(pernr);
        String usrid1 = StringHelper.null2String(hrTable.getString("USRID1"));
        humre.setObjno(usrid1);
        String ename = StringHelper.null2String(hrTable.getString("ENAME")).replace(" ", "");
        humre.setObjname(ename);
        String persg = StringHelper.null2String(hrTable.getString("PERSG"));
        if ("A".equals(persg.trim())) {
          humre.setExtselectitemfield11("40285a8f489c17ce0148f371f989673d");
        } else if ("B".equals(persg.trim())) {
          humre.setExtselectitemfield11("40285a8f489c17ce0148f371f98a673e");
          SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
          humre.setExtdatefield8(StringHelper.null2String(hrTable.getString("WKDATA")));
          humre.setExtdatefield9(sdf.format(DateUtils.addDays(sdf.parse(StringHelper.null2String(hrTable.getString("WKDATA"))), 179)));
        } else if ("C".equals(persg.trim())) {
          humre.setExtselectitemfield11("40285a8f489c17ce0148f371f98a673f");
          humre.setExtdatefield7(StringHelper.null2String(hrTable.getString("CMDATA")));
        } else if ("D".equals(persg.trim())) {
          humre.setExtselectitemfield11("40285a8f489c17ce0148f371f98a6740");
        } else if ("E".equals(persg.trim())) {
          humre.setExtselectitemfield11("40285a8f489c17ce0148f371f98a6741");
        } else if ("F".equals(persg.trim())) {
          humre.setExtselectitemfield11("40285a8f489c17ce0148f371f98a6742");
        } else if ("G".equals(persg.trim())) {
          humre.setExtselectitemfield11("40285a8f489c17ce0148f372f7b76749");
        } else {
          humre.setExtselectitemfield11("40285a8f489c17ce0148f372f7b7674a");
        }

        String persk = StringHelper.null2String(hrTable.getString("PERSK"));
        if ("10".equals(persk.trim()))
          humre.setExtselectitemfield12("40285a8f489c17ce0148f37425576768");
        else if ("15".equals(persk.trim()))
          humre.setExtselectitemfield12("40285a8f489c17ce0148f37425576769");
        else if ("20".equals(persk.trim()))
          humre.setExtselectitemfield12("40285a8f489c17ce0148f3742557676a");
        else if ("25".equals(persk.trim()))
          humre.setExtselectitemfield12("40285a8f489c17ce0148f3742557676b");
        else {
          humre.setExtselectitemfield12("40285a8f489c17ce0148f3742557676c");
        }

        String orgeh = StringHelper.null2String(hrTable.getString("ORGEH"));
        humre.setOrgid(this.orgService.findOrgunitBySap(orgeh).getId());

        humre.setOrgids(humre.getOrgid());

        humre.setExtmrefobjfield8(this.orgService.getOrgForHigher2(humre.getOrgid(), 1));
        humre.setExtmrefobjfield7(this.orgService.getOrgForHigher2(humre.getOrgid(), 2));
        humre.setExtmrefobjfield9(this.orgService.getOrgForHigher2(humre.getOrgid(), 0));
        humre.setExtrefobjfield10(this.orgService.getOrgForHigher2(humre.getOrgid(), 0));

        String plans = StringHelper.null2String(hrTable.getString("PLANS"));
        String stext = StringHelper.null2String(hrTable.getString("STEXT"));
        String themainstation = StringHelper.null2String(humre.getMainstation());
        humre.setMainstation(this.orgService.getStationForName(humre.getOrgid(), stext));
        if ((exist) && (!themainstation.equals(""))) {
          String thestations = StringHelper.null2String(humre.getStation());
          thestations = thestations.replace(themainstation, humre.getMainstation());
          humre.setStation(thestations);
        } else {
          humre.setStation(humre.getMainstation());
        }

        String trfar = StringHelper.null2String(hrTable.getString("TRFAR"));
        String trfgb = StringHelper.null2String(hrTable.getString("TRFGB"));
        String trfgr = StringHelper.null2String(hrTable.getString("TRFGR"));
        String trfst = StringHelper.null2String(hrTable.getString("TRFST"));
        humre.setExtrefobjfield4(this.orgService.getJob(trfar, trfgb, trfgr));
        humre.setExtrefobjfield5(this.orgService.getOrgunit(humre.getExtmrefobjfield9()).getTypeid());

        String zzck2 = StringHelper.null2String(hrTable.getString("ZZCK2"));
        if ("X".equals(zzck2.trim()))
          humre.setExtselectitemfield13("40288098276fc2120127704884290210");
        else {
          humre.setExtselectitemfield13("40288098276fc2120127704884290211");
        }
        String zzauf = StringHelper.null2String(hrTable.getString("ZZAUF"));
        humre.setExttextfield16(zzauf);

        int zzsel = StringHelper.isNumeric(hrTable.getString("ZZSEL")) ? Integer.parseInt(hrTable.getString("ZZSEL")) : 0;
        humre.setSeclevel(Integer.valueOf(zzsel));

        String ltext = StringHelper.null2String(hrTable.getString("LTEXT"));
        humre.setExttextfield25(ltext);
        String kostl = StringHelper.null2String(hrTable.getString("KOSTL"));
        humre.setExttextfield9(kostl);

        String gesch = StringHelper.null2String(hrTable.getString("GESCH"));
        if ("1".equals(gesch.trim()))
          humre.setGender("402881e90cba854b010cba9c9364000c");
        else {
          humre.setGender("402881e90cba854b010cba9c9364000d");
        }
        String gbdat = StringHelper.null2String(hrTable.getString("GBDAT"));
        humre.setExttimefield9(gbdat);

        String famst = StringHelper.null2String(hrTable.getString("FAMST"));
        if ("1".equals(famst.trim()))
          humre.setExtselectitemfield6("40288148117c8a5b01117cda3bb400ce");
        else {
          humre.setExtselectitemfield6("40288148117c8a5b01117cda3bb400cf");
        }
        String gbort = StringHelper.null2String(hrTable.getString("GBORT"));
        humre.setExttextfield23(gbort);

        String stext1 = StringHelper.null2String(hrTable.getString("STEXT1"));

        String slart = StringHelper.null2String(hrTable.getString("SLART"));
        if ("11".equals(slart.trim()))
          humre.setExtselectitemfield4("40285a8f4888284e0148985e911700a8");
        else if ("12".equals(slart.trim()))
          humre.setExtselectitemfield4("40285a8f4888284e0148985e911700a9");
        else if ("13".equals(slart.trim()))
          humre.setExtselectitemfield4("40285a8f4888284e0148985e911700aa");
        else if ("14".equals(slart.trim()))
          humre.setExtselectitemfield4("40285a8f4888284e0148985e911700ab");
        else if ("15".equals(slart.trim()))
          humre.setExtselectitemfield4("40285a8f489c17ce0148f2f648346273");
        else if ("16".equals(slart.trim()))
          humre.setExtselectitemfield4("40285a8f489c17ce0148f2f648346274");
        else if ("17".equals(slart.trim()))
          humre.setExtselectitemfield4("40285a8f489c17ce0148f2f648346275");
        else if ("18".equals(slart.trim()))
          humre.setExtselectitemfield4("40285a8f489c17ce0148f2f648346276");
        else if ("19".equals(slart.trim()))
          humre.setExtselectitemfield4("40285a8f489c17ce0148f2f648346278");
        else if ("20".equals(slart.trim()))
          humre.setExtselectitemfield4("40285a8f489c17ce0148f2f648346278");
        else if ("21".equals(slart.trim()))
          humre.setExtselectitemfield4("40285a8f489c17ce0148f2f648346279");
        else if ("22".equals(slart.trim()))
          humre.setExtselectitemfield4("40285a8f489c17ce0148f2f64834627a");
        else if ("23".equals(slart.trim()))
          humre.setExtselectitemfield4("40285a8f489c17ce0148f2f64834627b");
        else if ("24".equals(slart.trim()))
          humre.setExtselectitemfield4("40285a8f489c17ce0148f2f64834627c");
        else if ("25".equals(slart.trim()))
          humre.setExtselectitemfield4("40285a8f489c17ce0148f2f64834627d");
        else {
          humre.setExtselectitemfield4("40285a8f4888284e0148985e911700a7");
        }
        String usrid = StringHelper.null2String(hrTable.getString("USRID"));
        humre.setTel2(usrid);
        String cmdata = StringHelper.null2String(hrTable.getString("CMDATA"));
        humre.setExtdatefield0(cmdata);
        String wkdata = StringHelper.null2String(hrTable.getString("WKDATA"));
        humre.setExttextfield21(wkdata);
        String icnum = StringHelper.null2String(hrTable.getString("ICNUM"));
        humre.setCol1(icnum);
        String ltext1 = StringHelper.null2String(hrTable.getString("LTEXT1"));
        humre.setExtselectitemfield5(ltext1);
        humre.setHrstatus("4028804c16acfbc00116ccba13802935");

        if (exist) {
          this.hrService.modifyHumres(humre);
        } else {
          this.hrService.createHumres(humre);
          addSysuser(humre);
        }

        hrTable.nextRow();
      }
  }

  public void addSysuser(Humres humre)
  {
    this.suService = ((SysuserService)BaseContext.getBean("sysuserService"));
    Sysuser sysuser = new Sysuser();
    sysuser.setMtype(Integer.valueOf(1));
    sysuser.setLongonname(humre.getObjno());
    sysuser.setLogonpass("e10adc3949ba59abbe56e057f20f883e");
    sysuser.setObjid(humre.getId());
    sysuser.setIsclosed(Integer.valueOf(0));
    sysuser.setMainPageType("1");
    sysuser.setIsopenim(Integer.valueOf(0));
    sysuser.setSkinid("05A99452DB75D2D6E050007F010041B7");
    this.suService.createSysuser(sysuser);
  }
  public void addContract(Humres humre, String start, String end, String type) {
    this.baseJdbc = ((BaseJdbcDao)BaseContext.getBean("baseJdbcDao"));
    String userId = BaseContext.getRemoteUser().getId();
    StringBuffer buffer = new StringBuffer(1024);
    buffer.append("insert into uf_hr_contractinfo");
    buffer.append("(id,requestid,objnum,objname,orgid,mainstation,contracttype,constdate,conenddate) values");

    buffer.append("('").append(IDGernerator.getUnquieID())
      .append("',");
    buffer.append("'").append("$ewrequestid$").append("',");
    buffer.append("'").append(humre.getObjno()).append("',");
    buffer.append("'").append(humre.getId()).append("',");
    buffer.append("'").append(humre.getOrgid()).append("',");
    buffer.append("'").append(humre.getMainstation()).append("',");
    buffer.append("'").append(type).append("',");
    buffer.append("'").append(start).append("',");
    buffer.append("'").append(end).append("')");

    FormBase formBase = new FormBase();
    String categoryid = "40285a90497eab15014988d27d585135";

    formBase.setCreatedate(DateHelper.getCurrentDate());
    formBase.setCreatetime(DateHelper.getCurrentTime());
    formBase.setCreator(StringHelper.null2String(userId));
    formBase.setCategoryid(categoryid);
    formBase.setIsdelete(Integer.valueOf(0));
    FormBaseService formBaseService = (FormBaseService)
      BaseContext.getBean("formbaseService");
    formBaseService.createFormBase(formBase);
    String insertSql = buffer.toString();
    insertSql = insertSql.replace("$ewrequestid$", 
      formBase.getId());
    this.baseJdbc.update(insertSql);
    PermissionTool permissionTool = new PermissionTool();
    permissionTool.addPermission(categoryid, formBase.getId(), 
      "uf_hr_contractinfo");
  }

  public String getFunctionname()
  {
    return this.functionname;
  }

  public void setFunctionname(String functionname) {
    this.functionname = functionname;
  }
}