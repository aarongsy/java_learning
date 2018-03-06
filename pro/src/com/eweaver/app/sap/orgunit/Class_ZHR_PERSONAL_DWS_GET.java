package com.eweaver.app.sap.orgunit;

import com.eweaver.app.configsap.SapConnector;
import com.eweaver.base.BaseContext;
import com.eweaver.base.BaseJdbcDao;
import com.eweaver.base.DataService;
import com.eweaver.base.IDGernerator;
import com.eweaver.base.orgunit.model.Orgunit;
import com.eweaver.base.orgunit.service.OrgunitService;
import com.eweaver.base.util.StringHelper;
import com.eweaver.humres.base.model.Humres;
import com.eweaver.humres.base.service.HumresService;
import com.sap.conn.jco.JCoFunction;
import com.sap.conn.jco.JCoParameterList;
import com.sap.conn.jco.JCoTable;
import java.io.PrintStream;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import org.json.simple.JSONArray;

public class Class_ZHR_PERSONAL_DWS_GET
{
  public String functionname;

  public Class_ZHR_PERSONAL_DWS_GET(String functionname)
  {
    setFunctionname(functionname);
  }

  public JCoTable findData(String pernr, String begda, String endda) {
    try {
      String errorMessage = "";
      SapConnector sapConnector = new SapConnector();
      String functionName = "ZHR_PERSONAL_DWS_GET";
      JCoFunction function = SapConnector.getRfcFunction(functionName);
      if (function == null) {
        System.out.println(functionName + " not found in SAP.");
        System.out.println("SAP_RFC中没有此函数!");
        errorMessage = functionName + " not found in SAP.";
      }

      function.getImportParameterList().setValue("PERNR", pernr);
      function.getImportParameterList().setValue("BEGDA", begda);
      function.getImportParameterList().setValue("ENDDA", endda);

      function.execute(
        SapConnector.getDestination("sanpowersap"));
      JCoParameterList returnStructure = function.getTableParameterList();
      return function.getTableParameterList().getTable("PTPSP");
    } catch (Exception e) {
      e.printStackTrace();
    }

    return null;
  }

  public void syncClass(String ccpno, String begda, String endda)
    throws ParseException
  {
    OrgunitService orgService = (OrgunitService)BaseContext.getBean("orgunitService");
    HumresService hrService = (HumresService)BaseContext.getBean("humresService");
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    Humres humre = hrService.findHumreByCcp(ccpno);

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

    Class_ZHR_PERSONAL_DWS_GET app = new Class_ZHR_PERSONAL_DWS_GET(
      "ZHR_PERSONAL_DWS_GET");
    JCoTable classTable = app.findData(humre.getExttextfield15(), begda, endda);

    StringBuffer buffer = new StringBuffer(512);

    JSONArray array = new JSONArray();
    if (classTable != null)
      for (int i = 0; i < classTable.getNumRows(); i++) {
        String datum = StringHelper.null2String(classTable.getValue("DATUM"));
        datum = sdf.format(new Date(datum));
        String tprog = StringHelper.null2String(classTable.getValue("TPROG"));
        String ftkla = StringHelper.null2String(classTable.getValue("FTKLA"));
        if ("0".equals(ftkla))
          ftkla = "40288098276fc2120127704884290211";
        else {
          ftkla = "40288098276fc2120127704884290210";
        }
        String stdaz = StringHelper.null2String(classTable.getValue("STDAZ"));

        String comtype = orgService.getOrgunit(humre.getExtmrefobjfield9()).getTypeid();
        DataService ds = new DataService();
        List list = baseJdbc
          .executeSqlForList("select * from uf_hr_classplan where objname = '" + 
          humre.getId() + "' " + 
          "and thedate = '" + datum + "'");

        if (list.size() < 1) {
          buffer = new StringBuffer(512);

          buffer.append("insert into uf_hr_classplan");
          buffer.append("(id,requestid,sapjobno,jobno,objname,objdept,thedate,classno,classname,hours,comtype,yesno) values");

          buffer.append("('").append(IDGernerator.getUnquieID()).append("',");
          buffer.append("'").append(IDGernerator.getUnquieID()).append("',");
          buffer.append("'").append(humre.getExttextfield15()).append("',");
          buffer.append("'").append(humre.getObjno()).append("',");
          buffer.append("'").append(humre.getId()).append("',");
          buffer.append("'").append(humre.getOrgid()).append("',");
          buffer.append("'").append(datum).append("',");
          buffer.append("(select requestid from uf_hr_classinfo where classno = '");
          buffer.append(tprog).append("' and comtype like '%");
          buffer.append(comtype).append("%'),");
          buffer.append("(select classname from uf_hr_classinfo where classno = '");
          buffer.append(tprog).append("' and comtype like '%");
          buffer.append(comtype).append("%'),");
          buffer.append("'").append(stdaz).append("',");
          buffer.append("'").append(comtype).append("',");
          buffer.append("'").append(ftkla).append("')");

          String insertSql = buffer.toString();
          baseJdbc.update(insertSql);
        }
        else
        {
          buffer = new StringBuffer(512);
          buffer.append("update uf_hr_classplan set ");
          buffer.append("jobno = '").append(humre.getObjno()).append("',");
          buffer.append("objdept = '").append(humre.getOrgid()).append("',");
          buffer.append("classno = (select requestid from uf_hr_classinfo where classno = '");
          buffer.append(tprog).append("' and comtype like '%");
          buffer.append(comtype).append("%'),");
          buffer.append("classname = (select classname from uf_hr_classinfo where classno = '");
          buffer.append(tprog).append("' and comtype like '%");
          buffer.append(comtype).append("%'),");
          buffer.append("hours = '").append(stdaz).append("',");
          buffer.append("comtype = '").append(comtype).append("',");
          buffer.append("yesno = '").append(ftkla).append("' ");
          buffer.append(" where thedate = '").append(datum).append("'");
          buffer.append(" and objname = '").append(humre.getId()).append("'");

          String insertSql = buffer.toString();
          System.out.println(insertSql);
          baseJdbc.update(insertSql);
        }

        classTable.nextRow();
      }
  }

  public void saveOrg(String objid, String endda, String typeid, String parent, String dsporder, String objname)
  {
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    DataService ds = new DataService();
    List list = baseJdbc
      .executeSqlForList("select * from orgunit where isdelete <> 1 and objno = '" + 
      objid + "'");

    if (list.size() < 1) {
      String orgid = IDGernerator.getUnquieID();
      StringBuffer buffer = new StringBuffer(512);
      buffer.append("insert into orgunit");
      buffer.append("(id,objname,objno,typeid,dsporder,isdelete,unitstatus,reftype) values");
      buffer.append("('").append(orgid).append("',");
      buffer.append("'").append(objname).append("',");
      buffer.append("'").append(objid).append("',");
      buffer.append("'").append(typeid).append("',");
      buffer.append("'").append(dsporder).append("',");
      buffer.append("'0',");
      buffer.append("'").append(endda).append("',");
      buffer.append("'402881e510e8223c0110e83d427f0018')");

      String insertSql = buffer.toString();
      baseJdbc.update(insertSql);

      buffer = new StringBuffer(512);
      buffer.append("update orgunitlink set isdelete = '1' where oid = '").append(orgid).append("'");
      baseJdbc.update(insertSql);

      buffer = new StringBuffer(512);
      buffer.append("insert into orgunitlink");
      buffer.append("(id,oid,pid,typeid,col1,isdelete) values");
      buffer.append("('").append(IDGernerator.getUnquieID()).append("',");
      buffer.append("'").append(orgid).append("',");
      buffer.append(
        "(select id from orgunit where isdelete = 0 and objno = '")
        .append(parent).append("'),");
      buffer.append("'402881e510e8223c0110e83d427f0018',");
      buffer.append("(select get_all_orgid(id)||','||'").append(orgid)
        .append("' from orgunit where isdelete = 0 and objno = '")
        .append(parent).append("'),");
      buffer.append("'0')");

      insertSql = buffer.toString();
      baseJdbc.update(insertSql);
    }
    else {
      String orgid = ds.getValue("select id from orgunit where isdelete <> 1 and objno = '" + objid + "'");
      StringBuffer buffer = new StringBuffer(512);
      buffer.append("update orgunit set ");
      buffer.append("objname = '").append(objname).append("',");
      buffer.append("typeid = '").append(typeid).append("',");
      buffer.append("dsporder = '").append(dsporder).append("',");
      buffer.append("unitstatus = '").append(endda).append("' ");
      buffer.append(" where objno = '").append(objid).append("' and isdelete = '0'");

      String insertSql = buffer.toString();
      baseJdbc.update(insertSql);

      buffer = new StringBuffer(512);
      buffer.append("update orgunitlink set isdelete = '1' where oid = '").append(orgid).append("'");
      insertSql = buffer.toString();
      baseJdbc.update(insertSql);

      buffer = new StringBuffer(512);
      buffer.append("insert into orgunitlink");
      buffer.append("(id,oid,pid,typeid,col1,isdelete) values");
      buffer.append("('").append(IDGernerator.getUnquieID()).append("',");
      buffer.append("'").append(orgid).append("',");
      buffer.append(
        "(select id from orgunit where isdelete = 0 and objno = '")
        .append(parent).append("'),");
      buffer.append("'402881e510e8223c0110e83d427f0018',");
      buffer.append("(select get_all_orgid(id)||','||'").append(orgid)
        .append("' from orgunit where isdelete = 0 and objno = '")
        .append(parent).append("'),");
      buffer.append("'0')");

      insertSql = buffer.toString();
      baseJdbc.update(insertSql);
    }
  }

  public void getSAPData(String functionname)
  {
  }

  public String getFunctionname()
  {
    return this.functionname;
  }

  public void setFunctionname(String functionname) {
    this.functionname = functionname;
  }
}