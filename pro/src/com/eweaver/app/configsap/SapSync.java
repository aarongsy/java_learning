package com.eweaver.app.configsap;

import com.eweaver.base.BaseContext;
import com.eweaver.base.BaseJdbcDao;
import com.eweaver.base.DataService;
import com.eweaver.base.IDGernerator;
import com.eweaver.base.security.service.acegi.EweaverUser;
import com.eweaver.base.util.StringHelper;
import com.eweaver.humres.base.model.Humres;
import com.sap.conn.jco.JCoFunction;
import com.sap.conn.jco.JCoParameterList;
import com.sap.conn.jco.JCoTable;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

public class SapSync
{
  BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
  DataService dataService = new DataService();
  SapConfigService scService = new SapConfigService();

  public String syncSap(String configid, String requestid)
    throws Exception
  {
    SapConnector sapConnector = new SapConnector();
    SapConfig sc = this.scService.findSapConfigById(configid);

    if (sc == null) {
      return "not found configid";
    }
    JCoFunction function = SapConnector.getRfcFunction(sc.getName());

    if (function == null) {
      return "not found function";
    }

    inputSapParameter(sc, requestid, function);

    inputSapTable(sc, requestid, function);

    function.execute(SapConnector.getDestination("sanpowersap"));

    saveOutputSapParameter(sc, requestid, function);

    saveOutputSapTable(sc, requestid, function);

    return "SUCCESS";
  }

  private void saveOutputSapParameter(SapConfig sc, String requestid, JCoFunction function)
  {
    List outputs = this.scService.getOutputSapConfigs(sc.getRfcid());
    String updatesql = "update " + sc.getOtabname() + " set ";
    for (int i = 0; i < outputs.size(); i++) {
      if (i < outputs.size() - 1)
        updatesql = updatesql + ((SapConfig)outputs.get(i)).getOtabname() + " = '" + converValue(((SapConfig)outputs.get(i)).getOconvert(), StringHelper.null2String(function.getExportParameterList().getValue(((SapConfig)outputs.get(i)).getName()))) + "',";
      else
        updatesql = updatesql + ((SapConfig)outputs.get(i)).getOtabname() + " = '" + converValue(((SapConfig)outputs.get(i)).getOconvert(), StringHelper.null2String(function.getExportParameterList().getValue(((SapConfig)outputs.get(i)).getName()))) + "' ";
    }
    updatesql = updatesql + " where requestid = '" + requestid + "'";

    if (outputs.size() > 0)
      this.dataService.executeSql(updatesql);
  }

  private void saveOutputSapTable(SapConfig sc, String requestid, JCoFunction function)
  {
    Map outTable = this.scService.getOutTableSapConfigs(sc.getRfcid());
    JCoTable jcoTable;
    int i;
    for (Iterator localIterator = outTable.entrySet().iterator(); localIterator.hasNext();i=0;i< jcoTable.getNumRows();)
    {
      Map.Entry entry = (Map.Entry)localIterator.next();
      String delSql = "delete " + ((SapConfig)entry.getKey()).getOtabname() + " where requestid = '" + requestid + "'";
      this.dataService.executeSql(delSql);
      jcoTable = function.getTableParameterList().getTable(((SapConfig)entry.getKey()).getName());
      i = 0; continue;
      String insertcol = "insert into " + ((SapConfig)entry.getKey()).getOtabname() + "(id,requestid,";
      String insertvalue = " values('" + IDGernerator.getUnquieID() + "','" + requestid + "',";
      for (int j = 0; j < ((List)entry.getValue()).size(); j++) {
        if (j < ((List)entry.getValue()).size() - 1) {
          insertcol = insertcol + ((SapConfig)((List)entry.getValue()).get(j)).getOtabname() + ",";
          insertvalue = insertvalue + "'" + converValue(((SapConfig)((List)entry.getValue()).get(j)).getOconvert(), StringHelper.null2String(jcoTable.getValue(((SapConfig)((List)entry.getValue()).get(j)).getName()))) + "',";
        } else {
          insertcol = insertcol + ((SapConfig)((List)entry.getValue()).get(j)).getOtabname() + ")";
          insertvalue = insertvalue + "'" + converValue(((SapConfig)((List)entry.getValue()).get(j)).getOconvert(), StringHelper.null2String(jcoTable.getValue(((SapConfig)((List)entry.getValue()).get(j)).getName()))) + "')";
        }
      }

      this.dataService.executeSql(insertcol + insertvalue);
      jcoTable.nextRow();

      i++;
    }
  }

  public void inputSapTable(SapConfig sc, String requestid, JCoFunction function)
  {
    Map inTable = this.scService.getInTableSapConfigs(sc.getRfcid());
    List list;
    //int a=list.size();
    int i;
    for (Iterator localIterator = inTable.entrySet().iterator(); localIterator.hasNext(); i < list.size())
    {
      Map.Entry entry = (Map.Entry)localIterator.next();
      JCoTable jcoTable = function.getTableParameterList().getTable(((SapConfig)entry.getKey()).getName());
      list = this.baseJdbcDao.executeSqlForList("select * from " + ((SapConfig)entry.getKey()).getOtabname() + " where " + 
        "(exists(select 1 from requestbase r where r.id = requestid and isdelete = 0) " + 
        "or exists(select 1 from formbase f where f.id = requestid and isdelete = 0)) " + 
        "and requestid='" + requestid + "' ");
      i = 0; continue;
      Map map = (Map)list.get(i);
      jcoTable.appendRow();
      for (int j = 0; j < ((List)entry.getValue()).size(); j++)
        jcoTable.setValue(((SapConfig)((List)entry.getValue()).get(j)).getName(), getOvalue(map, (SapConfig)((List)entry.getValue()).get(j)));
      i++;
    }
  }

  public void inputSapParameter(SapConfig sc, String requestid, JCoFunction function)
  {
    Map atmap = 
      (Map)this.baseJdbcDao.executeSqlForList("select * from " + sc.getOtabname() + " where " + 
      "(exists(select 1 from requestbase r where r.id = requestid and isdelete = 0) " + 
      "or exists(select 1 from formbase f where f.id = requestid and isdelete = 0)) " + 
      "and requestid='" + requestid + "' ").get(0);
    List inputs = this.scService.getInputSapConfigs(sc.getRfcid());
    for (int i = 0; i < inputs.size(); i++)
      function.getImportParameterList().setValue(((SapConfig)inputs.get(i)).getName(), getOvalue(atmap, (SapConfig)inputs.get(i)));
  }

  public String getOvalue(Map atMap, SapConfig sc)
  {
    if ("curruser".equals(sc.getOtabname()))
      return BaseContext.getRemoteUser().getHumres().getExttextfield15();
    if ("currdate".equals(sc.getOtabname())) {
      SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
      return sdf.format(new Date());
    }if (sc.getOtabname().trim().length() > 0) {
      return dateValue(converValue(sc.getOconvert(), StringHelper.null2String(atMap.get(sc.getOtabname().trim()))));
    }
    return sc.getOconvert();
  }

  public String dateValue(String ovalue)
  {
    if ((ovalue.length() == 10) && (ovalue.indexOf("-") == 4) && (ovalue.lastIndexOf("-") == 7))
      ovalue = ovalue.replaceAll("-", "");
    else if ((ovalue.length() == 7) && (ovalue.indexOf("-") == 4))
      ovalue = ovalue.replaceAll("-", "");
    else if ((ovalue.length() == 8) && (ovalue.indexOf(":") == 2) && (ovalue.indexOf(":") == 5)) {
      ovalue = ovalue.replaceAll(":", "");
    }
    return ovalue;
  }

  public String converValue(String converStr, String ovalue)
  {
    String sql = converStr.replaceAll("currentFieldValue", ovalue);
    if (converStr.trim().length() > 0) {
      ovalue = this.dataService.getValue(sql);
    }
    return ovalue;
  }
}