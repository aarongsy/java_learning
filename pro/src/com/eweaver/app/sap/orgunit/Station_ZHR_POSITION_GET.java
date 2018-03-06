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

public class Station_ZHR_POSITION_GET
{
  public String functionname;

  public static void main(String[] str)
  {
    Station_ZHR_POSITION_GET app = new Station_ZHR_POSITION_GET(
      "ZHR_POSITION_GET");
    app.findData();
  }

  public Station_ZHR_POSITION_GET(String functionname)
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
      String functionName = "ZHR_POSITION_GET";
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

  public void syncStations(String orgid, String overdate)
  {
    String userId = BaseContext.getRemoteUser().getId();
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    Station_ZHR_POSITION_GET app = new Station_ZHR_POSITION_GET(
      "ZHR_POSITION_GET");
    JCoTable productTable = app.findData(orgid, overdate);

    JSONArray array = new JSONArray();

    if (productTable != null) {
      for (int i = 0; i < productTable.getNumRows(); i++) {
        String objname = StringHelper.null2String(productTable
          .getString("STEXT"));

        String endda = StringHelper.null2String(productTable
          .getString("ENDDA"));
        orgid = StringHelper.null2String(productTable
          .getString("ORGEH"));
        String dsporder = StringHelper.null2String(productTable
          .getString("SEQNR"));
        String chgor = StringHelper.null2String(productTable
          .getString("CHGOR"));
        String number = StringHelper.null2String(productTable
          .getString("NUMBER"));

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Date enddate;
        try {
          enddate = sdf.parse(endda);
        }
        catch (ParseException e)
        {
          Date enddate;
          enddate = new Date();
        }
        Date nowdate = new Date();
        if (nowdate.before(enddate))
          endda = "402880d319eb81720119eba4e1e70004";
        else {
          endda = "402880d319eb81720119eba4e1e70005";
        }

        saveSta(objname, endda, orgid, dsporder, chgor, number);
        productTable.nextRow();
      }
      baseJdbc.update("delete stationlink where isdelete = 1");
    }
  }

  public void saveSta(String objname, String endda, String orgid, String dsporder, String chgor, String number) {
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    DataService ds = new DataService();
    List list = baseJdbc
      .executeSqlForList("select * from stationinfo where isdelete <> 1 and orgid = (select max(id) from orgunit where col1 = '" + 
      orgid + "' and isdelete <> 1) and objname = '" + objname + "' ");

    if (list.size() < 1) {
      String staid = IDGernerator.getUnquieID();
      StringBuffer buffer = new StringBuffer(512);
      buffer.append("insert into stationinfo");
      buffer.append("(id,objname,orgid,dsporder,stationstatus,maxnum,curnum,isdelete,reftype,minlevel,maxlevel) values");
      buffer.append("('").append(staid).append("',");
      buffer.append("'").append(objname).append("',");
      buffer.append("(select max(id) from orgunit where col1 = '").append(orgid).append("'and isdelete <> 1),");
      buffer.append("'").append(dsporder).append("',");
      buffer.append("'").append(endda).append("',");
      buffer.append("'").append(number).append("',");
      buffer.append("'0',");
      buffer.append("'0',");
      buffer.append("'402881e510e8223c0110e83d427f0018',");
      buffer.append("'0',");
      buffer.append("'0')");

      String insertSql = buffer.toString();
      baseJdbc.update(insertSql);

      buffer = new StringBuffer(512);
      buffer.append("insert into stationlink");
      buffer.append("(id,oid,pid,typeid,pids,isdelete) values");
      buffer.append("('").append(IDGernerator.getUnquieID()).append("',");
      buffer.append("'").append(staid).append("',");
      buffer.append("get_sta_pid('").append(staid).append("'),");
      buffer.append("'402881e510e8223c0110e83d427f0018',");
      buffer.append("get_all_stid('").append(staid).append("'),");
      buffer.append("'0')");

      insertSql = buffer.toString();
      baseJdbc.update(insertSql);

      if (!"00000000".equals(chgor)) {
        buffer = new StringBuffer(512);
        buffer.append("update orgunit set mstationid = '");
        buffer.append(staid).append("' where isdelete = '0' and col1 = '");
        buffer.append(chgor).append("'");
        insertSql = buffer.toString();
        baseJdbc.update(insertSql);

        buffer = new StringBuffer(512);
        buffer.append("update orgunitlink set pmstationid = '");
        buffer.append(staid).append("' where pmstationid is null and isdelete = '0' and pid = (select id from orgunit where col1 = '");
        buffer.append(chgor).append("')");
        insertSql = buffer.toString();
        baseJdbc.update(insertSql);
      }
    }
    else {
      String staid = ds
        .getValue("select id from stationinfo where isdelete <> 1 and orgid = (select max(id) from orgunit where col1 = '" + orgid + "'and isdelete <> 1) and objname = '" + objname + "' ");
      StringBuffer buffer = new StringBuffer(512);
      buffer.append("update stationinfo set ");
      buffer.append("dsporder = '").append(dsporder).append("',");
      buffer.append("maxnum = '").append(number).append("',");
      buffer.append("stationstatus = '").append(endda).append("' ");
      buffer.append(" where objname = '").append(objname)
        .append("' and orgid = (select max(id) from orgunit where col1 = '")
        .append(orgid).append("' and isdelete <> 1) and isdelete = '0'");
      String insertSql = buffer.toString();
      baseJdbc.update(insertSql);

      buffer = new StringBuffer(512);
      buffer.append("update stationlink set isdelete = '1' where oid = '").append(staid).append("'");
      insertSql = buffer.toString();
      baseJdbc.update(insertSql);

      buffer = new StringBuffer(512);
      buffer.append("insert into stationlink");
      buffer.append("(id,oid,pid,typeid,pids,isdelete) values");
      buffer.append("('").append(IDGernerator.getUnquieID()).append("',");
      buffer.append("'").append(staid).append("',");
      buffer.append("get_sta_pid('").append(staid).append("'),");
      buffer.append("'402881e510e8223c0110e83d427f0018',");
      buffer.append("get_all_stid('").append(staid).append("'),");
      buffer.append("'0')");

      insertSql = buffer.toString();
      baseJdbc.update(insertSql);

      if (!"00000000".equals(chgor)) {
        buffer = new StringBuffer(512);
        buffer.append("update orgunit set mstationid = '");
        buffer.append(staid).append("' where isdelete = '0' and col1 = '");
        buffer.append(chgor).append("'");
        insertSql = buffer.toString();
        baseJdbc.update(insertSql);

        buffer = new StringBuffer(512);
        buffer.append("update orgunitlink set pmstationid = '");
        buffer.append(staid).append("' where pmstationid is null and isdelete = '0' and pid = (select id from orgunit where col1 = '");
        buffer.append(chgor).append("')");
        insertSql = buffer.toString();
        baseJdbc.update(insertSql);
      }
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