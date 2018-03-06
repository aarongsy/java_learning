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
import com.sap.conn.jco.JCoStructure;
import com.sap.conn.jco.JCoTable;
import java.io.PrintStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

public class ConfigSapAction
{
  BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
  DataService dataService = new DataService();

  public Map syncSap(String configid, String requestid)
    throws Exception
  {
    String sql = "";
    String errsql = "";
    String errcol = getErrCol(configid);
    SapConnector sapConnector = new SapConnector();
    String functionName = "";
    String omaintablename = "";
    sql = "select * from sapconfig where isdelete =0 and id='" + configid + "' and type='function'";
    List list = this.baseJdbcDao.executeSqlForList(sql);
    if (list.size() > 0) {
      Map map = (Map)list.get(0);
      functionName = StringHelper.null2String(map.get("name"));
      omaintablename = StringHelper.null2String(map.get("otabname"));
    }
    Map maintable = this.baseJdbcDao.executeForMap("select * from " + omaintablename + " where requestid='" + requestid + "'");
    JCoFunction function = SapConnector.getRfcFunction(functionName);

    if (function == null) {
      throw new Exception("rfc函数" + functionName + "不存在！");
    }

    sql = "select * from sapconfig where isdelete =0 and (otabname is not null or oconvert is not null) and pid in (select id from sapconfig where pid='" + configid + "' and type='input')";
    list = this.baseJdbcDao.executeSqlForList(sql);
    for (int i = 0; i < list.size(); i++)
    {
      Map map = (Map)list.get(i);
      String id = StringHelper.null2String(map.get("id"));
      String pid = StringHelper.null2String(map.get("pid"));
      String name = StringHelper.null2String(map.get("name"));
      String type = StringHelper.null2String(map.get("type"));
      String otabname = StringHelper.null2String(map.get("otabname"));
      String ofield = StringHelper.null2String(map.get("ofield"));
      String oconvert = StringHelper.null2String(map.get("oconvert"));
      oconvert = oconvert.trim();
      if (type.equals("table"))
        inputSapTable(id, name, requestid, otabname, function);
      else if (type.equals("structure"))
        inputSapStructure(id, name, requestid, otabname, function);
      else if (type.equals("parameter")) {
        inputSapParameter(name, otabname, maintable, oconvert, function);
      }
    }

    function.execute(SapConnector.getDestination("sanpowersap"));

    Map returnValueMap = new HashMap();
    sql = "select * from sapconfig where isdelete = 0 and (otabname is not null or oconvert is not null) and pid in (select id from sapconfig where pid='" + configid + "' and type='output')";
    list = this.baseJdbcDao.executeSqlForList(sql);
    for (int i = 0; i < list.size(); i++)
    {
      Map map = (Map)list.get(i);
      String id = StringHelper.null2String(map.get("id"));
      String pid = StringHelper.null2String(map.get("pid"));
      String name = StringHelper.null2String(map.get("name"));
      String type = StringHelper.null2String(map.get("type"));
      String otabname = StringHelper.null2String(map.get("otabname"));
      String ofield = StringHelper.null2String(map.get("ofield"));
      String oconvert = StringHelper.null2String(map.get("oconvert"));
      oconvert = oconvert.trim();
      if (type.equals("table"))
        outputSapTable(returnValueMap, id, name, requestid, otabname, function);
      else if (type.equals("structure"))
        outputSapStructure(returnValueMap, id, name, otabname, function);
      else if (type.equals("parameter")) {
        outputSapParameter(returnValueMap, name, otabname, oconvert, function);
      }

    }

    String updatesql = "update " + omaintablename + " set ";

    Iterator it = returnValueMap.entrySet().iterator();
    while (it.hasNext())
    {
      Map.Entry pairs = (Map.Entry)it.next();

      if ("ArrayList".equals(pairs.getValue().getClass().getSimpleName())) {
        List details = (List)pairs.getValue();
        this.dataService.executeSql("delete " + pairs.getKey() + " where requestid = '" + requestid + "'");
        String nodeid = this.dataService.getValue("select nodeid from " + pairs.getKey() + " where requestid = '" + requestid + "'");
        for (int i = 0; i < details.size(); i++) {
          String insertheader = "insert into " + pairs.getKey() + "(id,requestid,nodeid,rowindex,";
          String insertfooder = ")values('" + IDGernerator.getUnquieID() + "','" + requestid + "','" + StringHelper.null2String(nodeid) + "','" + StringHelper.specifiedLengthForInt(i, 3) + "',";

          Iterator ait = ((Map)details.get(i)).entrySet().iterator();
          while (ait.hasNext()) {
            Map.Entry detail = (Map.Entry)ait.next();
            insertheader = insertheader + detail.getKey().toString().trim() + ",";
            insertfooder = insertfooder + "'" + detail.getValue().toString().trim() + "',";
          }
          if (insertfooder.length() > 8)
            this.dataService.executeSql(insertheader.substring(0, insertheader.lastIndexOf(",")) + insertfooder.substring(0, insertfooder.lastIndexOf(",")) + ")");
        }
      }
      else {
        updatesql = updatesql + pairs.getKey() + " = '" + pairs.getValue() + "',";
      }
      if ((errcol.equals(StringHelper.null2String(pairs.getKey()))) && ("E".equals(StringHelper.null2String(pairs.getValue())))) {
        errsql = "insert into saperror(reqid,msgty) values('" + requestid + "','" + pairs.getValue() + "')";
      }
    }
    updatesql = updatesql.substring(0, updatesql.lastIndexOf(","));
    updatesql = updatesql + " where requestid = '" + requestid + "'";
    System.out.println(updatesql);
    this.dataService.executeSql(updatesql);
    if (errsql.length() > 9) {
      this.dataService.executeSql(errsql);
    }
    return returnValueMap;
  }

  private void outputSapParameter(Map map, String sapname, String oname, String converStr, JCoFunction function) {
    String returnValue = function.getExportParameterList().getValue(sapname).toString();

    returnValue = converValue(converStr, returnValue);
    if (StringHelper.isEmpty(oname)) {
      oname = sapname;
    }
    map.put(oname, returnValue);
  }

  private void outputSapStructure(Map map, String pid, String name, String otabname, JCoFunction function)
  {
    JCoStructure jcoStructure = function.getExportParameterList().getStructure(name);
    List fieldlist = this.baseJdbcDao.executeSqlForList("select * from sapconfig where isdelete =0 and pid='" + pid + "'");
    if (StringHelper.isEmpty(otabname)) {
      otabname = name;
    }
    Map dsMap = new HashMap();
    map.put(otabname, dsMap);
    for (int j = 0; j < fieldlist.size(); j++) {
      Map fieldmap = (Map)fieldlist.get(j);
      String sapfieldname = StringHelper.null2String(fieldmap.get("name"));
      String ofieldname = StringHelper.null2String(fieldmap.get("otabname"));
      String oconvert = StringHelper.null2String(fieldmap.get("oconvert"));
      String ovalue = jcoStructure.getString(sapfieldname);
      if (StringHelper.isEmpty(ofieldname)) {
        ofieldname = sapfieldname;
      }
      dsMap.put(ofieldname, ovalue);
    }
  }

  private void outputSapTable(Map map, String id, String saptableName, String requestid, String otabname, JCoFunction function)
  {
    List returnList = new ArrayList();
    if (StringHelper.isEmpty(otabname)) {
      otabname = saptableName;
    }
    JCoTable jcoTable = function.getTableParameterList().getTable(saptableName);
    List fieldlist = this.baseJdbcDao.executeSqlForList("select * from sapconfig where isdelete =0 and (otabname is not null or oconvert is not null) and pid='" + id + "'");
    for (int i = 0; i < jcoTable.getNumRows(); i++) {
      jcoTable.setRow(i);
      Map rowMap = new HashMap();
      for (int j = 0; j < fieldlist.size(); j++) {
        Map fieldmap = (Map)fieldlist.get(j);
        String sapfieldname = StringHelper.null2String(fieldmap.get("name"));
        String ofieldname = StringHelper.null2String(fieldmap.get("otabname"));
        String oconvert = StringHelper.null2String(fieldmap.get("oconvert"));
        String ovalue = jcoTable.getString(sapfieldname);
        ovalue = converValue(oconvert, ovalue);
        if (StringHelper.isEmpty(ofieldname)) {
          ofieldname = sapfieldname;
        }
        rowMap.put(ofieldname, ovalue);
      }
      returnList.add(rowMap);
    }
    map.put(otabname, returnList);
  }

  public void inputSapTable(String id, String saptableName, String requestid, String otablename, JCoFunction function)
  {
    JCoTable jcoTable = function.getTableParameterList().getTable(saptableName);
    List fieldlist = this.baseJdbcDao.executeSqlForList("select * from sapconfig where isdelete =0 and (otabname is not null or oconvert is not null) and pid='" + id + "'");
    List list = this.baseJdbcDao.executeSqlForList("select * from " + otablename + " where requestid='" + requestid + "'");
    for (int i = 0; i < list.size(); i++) {
      jcoTable.appendRow();
      Map map = (Map)list.get(i);
      for (int j = 0; j < fieldlist.size(); j++) {
        Map fieldmap = (Map)fieldlist.get(j);
        String sapfieldname = StringHelper.null2String(fieldmap.get("name"));
        String ofieldname = StringHelper.null2String(fieldmap.get("otabname"));
        String oconvert = StringHelper.null2String(fieldmap.get("oconvert"));
        oconvert = oconvert.trim();
        String ovalue = StringHelper.null2String(map.get(ofieldname));

        ovalue = oconvert;
        if ("curruser".equals(ofieldname)) {
          ovalue = BaseContext.getRemoteUser().getHumres().getExttextfield15();
        } else if ("currdate".equals(ofieldname)) {
          SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
          ovalue = sdf.format(new Date());
        } else if (ofieldname.length() > 0) {
          ovalue = StringHelper.null2String(map.get(ofieldname));
          if ((!"".equals(oconvert.trim())) && (oconvert.trim().length() > 0)) {
            ovalue = converValue(oconvert, ovalue);
          }
          ovalue = dateValue(ovalue);
        }

        jcoTable.setValue(sapfieldname, ovalue);
      }
    }
  }

  public void inputSapStructure(String id, String saptableName, String requestid, String otablename, JCoFunction function)
  {
    JCoStructure jcoStructure = function.getImportParameterList().getStructure(saptableName);
    List fieldlist = this.baseJdbcDao.executeSqlForList("select * from sapconfig where isdelete =0 and (otabname is not null or oconvert is not null) and pid='" + id + "'");
    List list = this.baseJdbcDao.executeSqlForList("select * from " + otablename + " where requestid='" + requestid + "'");
    for (int i = 0; i < list.size(); i++) {
      Map map = (Map)list.get(i);
      for (int j = 0; j < fieldlist.size(); j++) {
        Map fieldmap = (Map)fieldlist.get(j);
        String sapfieldname = StringHelper.null2String(fieldmap.get("name"));
        String ofieldname = StringHelper.null2String(fieldmap.get("otabname"));
        String oconvert = StringHelper.null2String(fieldmap.get("oconvert"));
        String ovalue = StringHelper.null2String(map.get(ofieldname));
        ovalue = converValue(oconvert, ovalue);
        jcoStructure.setValue(sapfieldname, ovalue);
      }
    }
  }

  public void inputSapParameter(String sapparamname, String ofield, Map map, String oconvert, JCoFunction function)
  {
    String ovalue = oconvert;
    if ("curruser".equals(ofield)) {
      ovalue = BaseContext.getRemoteUser().getHumres().getExttextfield15();
    } else if ("currdate".equals(ofield)) {
      SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
      ovalue = sdf.format(new Date());
    } else if (ofield.length() > 0) {
      ovalue = StringHelper.null2String(map.get(ofield));
      if ((!"".equals(oconvert.trim())) && (oconvert.trim().length() > 0)) {
        ovalue = converValue(oconvert, ovalue);
      }
      ovalue = dateValue(ovalue);
    }
    function.getImportParameterList().setValue(sapparamname, ovalue);
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

  public String getErrCol(String configid)
  {
    String sql = "select otabname from sapconfig where type = 'parameter' and name = 'MSGTY' and isdelete = 0 and rfcid = '" + configid + "'";
    String colname = StringHelper.null2String(this.dataService.getValue(sql));
    return colname;
  }
}