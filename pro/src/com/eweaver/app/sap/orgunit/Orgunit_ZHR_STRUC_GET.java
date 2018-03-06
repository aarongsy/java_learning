package com.eweaver.app.sap.orgunit;

import com.eweaver.app.configsap.SapConnector;
import com.eweaver.base.BaseContext;
import com.eweaver.base.BaseJdbcDao;
import com.eweaver.base.DataService;
import com.eweaver.base.IDGernerator;
import com.eweaver.base.security.service.acegi.EweaverUser;
import com.eweaver.base.util.StringHelper;
import com.sap.conn.jco.JCoFunction;
import com.sap.conn.jco.JCoParameterList;
import com.sap.conn.jco.JCoTable;
import java.io.PrintStream;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import org.json.simple.JSONArray;

public class Orgunit_ZHR_STRUC_GET
{
  public String functionname;

  public static void main(String[] str)
  {
    Orgunit_ZHR_STRUC_GET app = new Orgunit_ZHR_STRUC_GET("ZHR_STRUC_GET");
    app.findData();
  }

  public Orgunit_ZHR_STRUC_GET(String functionname)
  {
    setFunctionname(functionname);
  }

  public JCoTable findData() {
    return findData("10100000", "");
  }

  public JCoTable findData(String orgeh, String overdate) {
    try {
      String errorMessage = "";
      SapConnector sapConnector = new SapConnector();
      String functionName = "ZHR_STRUC_GET";
      JCoFunction function = SapConnector.getRfcFunction(functionName);
      if (function == null) {
        System.out.println(functionName + " not found in SAP.");
        System.out.println("SAP_RFC中没有此函数!");
        errorMessage = functionName + " not found in SAP.";
      }

      function.getImportParameterList().setValue("ORGEH", orgeh);
      if (!"".equals(overdate)) {
        function.getImportParameterList().setValue("KDATE", overdate);
      }

      function.execute(
        SapConnector.getDestination("sanpowersap"));
      JCoParameterList returnStructure = function.getTableParameterList();
      return function.getTableParameterList().getTable("OBJEC");
    } catch (Exception e) {
      e.printStackTrace();
    }

    return null;
  }

  public void syncOrgunit(String objid, String overdate)
  {
    String userId = BaseContext.getRemoteUser().getId();
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    Orgunit_ZHR_STRUC_GET app = new Orgunit_ZHR_STRUC_GET(
      "ZHR_STRUC_GET");
    JCoTable productTable = app.findData(objid, overdate);

    JSONArray array = new JSONArray();
    if (productTable != null) {
      for (int i = 0; i < productTable.getNumRows(); i++)
      {
        objid = StringHelper.null2String(productTable
          .getString("OBJID"));
        String comid = StringHelper.null2String(productTable
          .getString("BUKRS"));

        String endda = StringHelper.null2String(productTable
          .getString("ENDDA"));

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Date enddate;
        try
        {
          enddate = sdf.parse(endda);
        }
        catch (ParseException e)
        {
          Date enddate;
          enddate = new Date();
        }
        Date nowdate = new Date();
        if (nowdate.before(enddate))
          endda = "402880d31a04dfba011a04e4db5f0003";
        else {
          endda = "402880d31a04dfba011a04e4db5f0004";
        }
        String typeid = StringHelper.null2String(productTable
          .getString("OMLVL"));

        if ("10".equals(typeid.trim()))
          typeid = "4028804d2083a7ed012083d123de0025";
        else if ("20".equals(typeid.trim()))
          typeid = "2c91a0302b19639f012b196ec20e0010";
        else if ("30".equals(typeid.trim()))
          typeid = "2c91a0302a87f19c012a894ce1650003";
        else if ("40".equals(typeid.trim()))
          typeid = "40285a8f487e198301487ee418d8000c";
        else {
          typeid = "";
        }
        String parent = StringHelper.null2String(productTable
          .getString("PARENT"));
        String dsporder = StringHelper.null2String(productTable
          .getString("SEQNR"));
        String objname = StringHelper.null2String(productTable
          .getString("STEXT"));

        if (!"00000000".equals(parent))
          saveOrg(comid, objid, endda, typeid, parent, dsporder, objname);
        productTable.nextRow();
      }
      baseJdbc.update("delete orgunitlink where isdelete = 1");
    }
  }

  public void saveOrg(String comid, String objid, String endda, String typeid, String parent, String dsporder, String objname)
  {
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    DataService ds = new DataService();
    List list = baseJdbc
      .executeSqlForList("select * from orgunit where isdelete <> 1 and col1 = '" + 
      objid + "'");

    if (list.size() < 1) {
      String orgid = IDGernerator.getUnquieID();
      StringBuffer buffer = new StringBuffer(512);
      buffer.append("insert into orgunit");
      buffer.append("(id,objname,objno,col1,typeid,dsporder,isdelete,unitstatus,reftype) values");
      buffer.append("('").append(orgid).append("',");
      buffer.append("'").append(objname).append("',");
      buffer.append("'").append(comid).append("',");
      buffer.append("'").append(objid).append("',");
      buffer.append("'").append(typeid).append("',");
      buffer.append("'").append(dsporder).append("',");
      buffer.append("'0',");
      buffer.append("'").append(endda).append("',");
      buffer.append("'402881e510e8223c0110e83d427f0018')");

      String insertSql = buffer.toString();
      baseJdbc.update(insertSql);

      buffer = new StringBuffer(512);
      buffer.append("insert into orgunitlink");
      buffer.append("(id,oid,pid,typeid,col1,isdelete) values");
      buffer.append("('").append(IDGernerator.getUnquieID()).append("',");
      buffer.append("'").append(orgid).append("',");
      buffer.append(
        "(select id from orgunit where isdelete = 0 and col1 = '")
        .append(parent).append("'),");
      buffer.append("'402881e510e8223c0110e83d427f0018',");
      buffer.append("(select get_all_orgid(id)||','||'").append(orgid)
        .append("' from orgunit where isdelete = 0 and col1 = '")
        .append(parent).append("'),");
      buffer.append("'0')");

      insertSql = buffer.toString();
      baseJdbc.update(insertSql);
    }
    else {
      String orgid = ds.getValue("select id from orgunit where isdelete <> 1 and col1 = '" + objid + "'");
      StringBuffer buffer = new StringBuffer(512);
      buffer.append("update orgunit set ");
      buffer.append("objname = '").append(objname).append("',");
      if (typeid.length() > 10)
        buffer.append("typeid = '").append(typeid).append("',");
      buffer.append("dsporder = '").append(dsporder).append("',");
      buffer.append("objno = '").append(comid).append("',");
      buffer.append("unitstatus = '").append(endda).append("' ");
      buffer.append(" where col1 = '").append(objid).append("' and isdelete = '0'");

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
        "(select id from orgunit where isdelete = 0 and col1 = '")
        .append(parent).append("'),");
      buffer.append("'402881e510e8223c0110e83d427f0018',");
      buffer.append("(select get_all_orgid(id)||','||'").append(orgid)
        .append("' from orgunit where isdelete = 0 and col1 = '")
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