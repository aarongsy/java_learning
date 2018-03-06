package com.eweaver.app.configsap;

import com.eweaver.base.BaseContext;
import com.eweaver.base.BaseJdbcDao;
import com.eweaver.base.DataService;
import com.eweaver.base.IDGernerator;
import com.eweaver.base.util.StringHelper;
import com.eweaver.workflow.form.model.Formfield;
import com.eweaver.workflow.form.model.Forminfo;
import com.eweaver.workflow.form.service.FormfieldService;
import com.eweaver.workflow.form.service.ForminfoService;
import com.sap.conn.jco.JCoFunction;
import com.sap.conn.jco.JCoMetaData;
import com.sap.conn.jco.JCoParameterList;
import com.sap.conn.jco.JCoTable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class SapConfigService
{
  public String createRfc(SapConfig function)
    throws Exception
  {
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    StringBuffer buffer = new StringBuffer(256);
    buffer.append("select * from sapconfig where isdelete = 0 and name = ");
    buffer.append("'").append(function.getName()).append("' ");
    buffer.append("and otabname = '").append(function.getOtabname()).append("'");
    String sql = buffer.toString();
    if (baseJdbc.executeSqlForList(sql).size() > 0) {
      return "exists";
    }
    JCoFunction rfc = SapConnector.getRfcFunction(function.getName());
    if (rfc == null) {
      return "notfind";
    }

    List sapConfigList = new ArrayList();
    function.setRfcid(function.getId());
    sapConfigList.add(function);
    SapConfig input = new SapConfig(IDGernerator.getUnquieID(), function.getId(), "输入参数", "所有输入参数", "input", "", "", "", "", "0", function.getId());
    sapConfigList.add(input);
    SapConfig output = new SapConfig(IDGernerator.getUnquieID(), function.getId(), "输出参数", "所有输出参数", "output", "", "", "", "", "0", function.getId());
    sapConfigList.add(output);

    addInputParameters(sapConfigList, input, rfc);

    addOutputParameters(sapConfigList, output, rfc);

    addTable(sapConfigList, input, rfc);

    saveSapConfigs(sapConfigList);

    return function.getId();
  }

  public String overloadRfc(SapConfig function)
    throws Exception
  {
    JCoFunction rfc = SapConnector.getRfcFunction(function.getName());

    overloadInputParameters(function, rfc);

    overloadOutputParameters(function, rfc);

    overloadTables(function, rfc);

    overloadColumns(function, rfc);

    return function.getId();
  }

  public List<SapConfig> addTable(List<SapConfig> sapConfigList, SapConfig input, JCoFunction rfc)
  {
    if (rfc.getTableParameterList() != null)
      for (int i = 0; i < rfc.getTableParameterList().getMetaData().getFieldCount(); i++) {
        SapConfig sc = new SapConfig();
        sc.setId(IDGernerator.getUnquieID());
        sc.setPid(input.getId());
        sc.setName(rfc.getTableParameterList().getMetaData().getName(i));
        sc.setRemark(rfc.getTableParameterList().getMetaData().getDescription(i));
        sc.setType("table");
        sc.setOtabname("");
        sc.setOfield("");
        sc.setOconvert("");
        sc.setOremark("");
        sc.setIsdelete("0");
        sc.setRfcid(input.getRfcid());
        sapConfigList.add(sc);
        addColnums(sapConfigList, sc, rfc);
      }
    return sapConfigList;
  }

  public List<SapConfig> addColnums(List<SapConfig> sapConfigList, SapConfig table, JCoFunction rfc)
  {
    if (rfc.getTableParameterList().getTable(table.getName()) != null)
      for (int i = 0; i < rfc.getTableParameterList().getTable(table.getName()).getMetaData().getFieldCount(); i++) {
        SapConfig sc = new SapConfig();
        sc.setId(IDGernerator.getUnquieID());
        sc.setPid(table.getId());
        sc.setName(rfc.getTableParameterList().getTable(table.getName()).getMetaData().getName(i));
        sc.setRemark(rfc.getTableParameterList().getTable(table.getName()).getMetaData().getDescription(i));
        sc.setType("column");
        sc.setOtabname("");
        sc.setOfield("");
        sc.setOconvert("");
        sc.setOremark("");
        sc.setIsdelete("0");
        sc.setRfcid(table.getRfcid());
        sapConfigList.add(sc);
      }
    return sapConfigList;
  }

  public List<SapConfig> addInputParameters(List<SapConfig> sapConfigList, SapConfig input, JCoFunction rfc)
  {
    if (rfc.getImportParameterList() != null)
      for (int i = 0; i < rfc.getImportParameterList().getMetaData().getFieldCount(); i++) {
        SapConfig sc = new SapConfig();
        sc.setId(IDGernerator.getUnquieID());
        sc.setPid(input.getId());
        sc.setName(rfc.getImportParameterList().getMetaData().getName(i));
        sc.setRemark(rfc.getImportParameterList().getMetaData().getDescription(i));
        sc.setType("parameter");
        sc.setOtabname("");
        sc.setOfield("");
        sc.setOconvert("");
        sc.setOremark("");
        sc.setIsdelete("0");
        sc.setRfcid(input.getRfcid());
        sapConfigList.add(sc);
      }
    return sapConfigList;
  }

  public List<SapConfig> addOutputParameters(List<SapConfig> sapConfigList, SapConfig output, JCoFunction rfc)
  {
    if (rfc.getExportParameterList() != null)
      for (int i = 0; i < rfc.getExportParameterList().getMetaData().getFieldCount(); i++) {
        SapConfig sc = new SapConfig();
        sc.setId(IDGernerator.getUnquieID());
        sc.setPid(output.getId());
        sc.setName(rfc.getExportParameterList().getMetaData().getName(i));
        sc.setRemark(rfc.getExportParameterList().getMetaData().getDescription(i));
        sc.setType("parameter");
        sc.setOtabname("");
        sc.setOfield("");
        sc.setOconvert("");
        sc.setOremark("");
        sc.setIsdelete("0");
        sc.setRfcid(output.getRfcid());
        sapConfigList.add(sc);
      }
    return sapConfigList;
  }

  public int saveSapConfigs(List<SapConfig> scs)
  {
    int retnum = 0;
    for (int i = 0; i < scs.size(); i++) {
      retnum += saveSapConfig((SapConfig)scs.get(i));
    }
    return retnum;
  }

  public int saveSapConfig(SapConfig sc)
  {
    int retnum = 0;
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    StringBuffer buffer = new StringBuffer(1024);
    buffer.append("insert into sapconfig");
    buffer.append("(id,pid,name,remark,type,otabname,ofield,oconvert,oremark,isdelete,rfcid) values(");
    buffer.append("'").append(sc.getId()).append("',");
    buffer.append("'").append(sc.getPid()).append("',");
    buffer.append("'").append(sc.getName()).append("',");
    buffer.append("'").append(sc.getRemark()).append("',");
    buffer.append("'").append(sc.getType()).append("',");
    buffer.append("'").append(sc.getOtabname()).append("',");
    buffer.append("'").append(sc.getOfield()).append("',");
    buffer.append("'").append(sc.getOconvert()).append("',");
    buffer.append("'").append(sc.getOremark()).append("',");
    buffer.append("'").append(sc.getIsdelete()).append("',");
    buffer.append("'").append(sc.getRfcid()).append("')");

    String insertSql = buffer.toString();
    retnum = baseJdbc.update(insertSql);
    return retnum;
  }

  public SapConfig findSapConfigById(String id)
  {
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    StringBuffer buffer = new StringBuffer(1024);
    buffer.append("select * from sapconfig where isdelete = 0 and id = ");
    buffer.append("'").append(id).append("'");
    String sql = buffer.toString();
    List list = baseJdbc.executeSqlForList(sql);
    SapConfig sc = new SapConfig();
    if (list.size() > 0) {
      Map map = (Map)list.get(0);
      sc.setId(StringHelper.null2String(map.get("id")));
      sc.setPid(StringHelper.null2String(map.get("pid")));
      sc.setName(StringHelper.null2String(map.get("name")));
      sc.setRemark(StringHelper.null2String(map.get("remark")));
      sc.setType(StringHelper.null2String(map.get("type")));
      sc.setOtabname(StringHelper.null2String(map.get("otabname")));
      sc.setOfield(StringHelper.null2String(map.get("ofield")));
      sc.setOconvert(StringHelper.null2String(map.get("oconvert")));
      sc.setOremark(StringHelper.null2String(map.get("oremark")));
      sc.setIsdelete(StringHelper.null2String(map.get("isdelete")));
      sc.setRfcid(StringHelper.null2String(map.get("rfcid")));
    } else {
      sc = null;
    }
    return sc;
  }

  public String inputId(String rfcid)
  {
    DataService ds = new DataService();
    StringBuffer buffer = new StringBuffer(256);
    buffer.append("select id from sapconfig where type = 'input' and isdelete = 0 and rfcid = ");
    buffer.append("'").append(rfcid).append("'");
    return ds.getValue(buffer.toString());
  }

  public String outputId(String rfcid)
  {
    DataService ds = new DataService();
    StringBuffer buffer = new StringBuffer(256);
    buffer.append("select id from sapconfig where type = 'output' and isdelete = 0 and rfcid = ");
    buffer.append("'").append(rfcid).append("'");
    return ds.getValue(buffer.toString());
  }

  public List<SapConfig> findSapConfigs(String id)
  {
    List sapConfigList = new ArrayList();
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    StringBuffer buffer = new StringBuffer(256);
    buffer.append("select * from sapconfig where isdelete = 0 and rfcid = ");
    buffer.append("'").append(id).append("'");
    String sql = buffer.toString();
    List list = baseJdbc.executeSqlForList(sql);
    for (int i = 0; i < list.size(); i++) {
      SapConfig sc = new SapConfig();
      Map map = (Map)list.get(i);
      sc.setId(StringHelper.null2String(map.get("id")));
      sc.setPid(StringHelper.null2String(map.get("pid")));
      sc.setName(StringHelper.null2String(map.get("name")));
      sc.setRemark(StringHelper.null2String(map.get("remark")));
      sc.setType(StringHelper.null2String(map.get("type")));
      sc.setOtabname(StringHelper.null2String(map.get("otabname")));
      sc.setOfield(StringHelper.null2String(map.get("ofield")));
      sc.setOconvert(StringHelper.null2String(map.get("oconvert")));
      sc.setOremark(StringHelper.null2String(map.get("oremark")));
      sc.setIsdelete(StringHelper.null2String(map.get("isdelete")));
      sc.setRfcid(StringHelper.null2String(map.get("rfcid")));
      sapConfigList.add(sc);
    }
    return sapConfigList;
  }

  public List<SapConfig> findSapConfigsByPid(String pid)
  {
    List sapConfigList = new ArrayList();
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    StringBuffer buffer = new StringBuffer(256);
    buffer.append("select * from sapconfig where isdelete = 0 and pid = ");
    buffer.append("'").append(pid).append("'");
    String sql = buffer.toString();
    List list = baseJdbc.executeSqlForList(sql);
    for (int i = 0; i < list.size(); i++) {
      SapConfig sc = new SapConfig();
      Map map = (Map)list.get(i);
      sc.setId(StringHelper.null2String(map.get("id")));
      sc.setPid(StringHelper.null2String(map.get("pid")));
      sc.setName(StringHelper.null2String(map.get("name")));
      sc.setRemark(StringHelper.null2String(map.get("remark")));
      sc.setType(StringHelper.null2String(map.get("type")));
      sc.setOtabname(StringHelper.null2String(map.get("otabname")));
      sc.setOfield(StringHelper.null2String(map.get("ofield")));
      sc.setOconvert(StringHelper.null2String(map.get("oconvert")));
      sc.setOremark(StringHelper.null2String(map.get("oremark")));
      sc.setIsdelete(StringHelper.null2String(map.get("isdelete")));
      sc.setRfcid(StringHelper.null2String(map.get("rfcid")));
      sapConfigList.add(sc);
    }
    return sapConfigList;
  }

  public List<SapConfig> findTables(String id)
  {
    List sapConfigList = new ArrayList();
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    StringBuffer buffer = new StringBuffer(256);
    buffer.append("select * from sapconfig where isdelete = 0 and type = 'table' ");
    buffer.append("and rfcid = '").append(id).append("' ");
    buffer.append("and pid in (select id from sapconfig where isdelete = 0 ");
    buffer.append("and pid='").append(id).append("')");

    String sql = buffer.toString();
    List list = baseJdbc.executeSqlForList(sql);
    for (int i = 0; i < list.size(); i++) {
      SapConfig sc = new SapConfig();
      Map map = (Map)list.get(i);
      sc.setId(StringHelper.null2String(map.get("id")));
      sc.setPid(StringHelper.null2String(map.get("pid")));
      sc.setName(StringHelper.null2String(map.get("name")));
      sc.setRemark(StringHelper.null2String(map.get("remark")));
      sc.setType(StringHelper.null2String(map.get("type")));
      sc.setOtabname(StringHelper.null2String(map.get("otabname")));
      sc.setOfield(StringHelper.null2String(map.get("ofield")));
      sc.setOconvert(StringHelper.null2String(map.get("oconvert")));
      sc.setOremark(StringHelper.null2String(map.get("oremark")));
      sc.setIsdelete(StringHelper.null2String(map.get("isdelete")));
      sc.setRfcid(StringHelper.null2String(map.get("rfcid")));
      sapConfigList.add(sc);
    }
    return sapConfigList;
  }

  public List<SapConfig> findInputSapConfigs(String id)
  {
    List sapConfigList = new ArrayList();
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    StringBuffer buffer = new StringBuffer(256);
    buffer.append("select * from sapconfig where isdelete = 0 and type = 'parameter' ");
    buffer.append("and rfcid = '").append(id).append("' ");
    buffer.append("and pid in (select id from sapconfig where type='input' and isdelete = 0 ");
    buffer.append("and pid='").append(id).append("')");

    String sql = buffer.toString();
    List list = baseJdbc.executeSqlForList(sql);
    for (int i = 0; i < list.size(); i++) {
      SapConfig sc = new SapConfig();
      Map map = (Map)list.get(i);
      sc.setId(StringHelper.null2String(map.get("id")));
      sc.setPid(StringHelper.null2String(map.get("pid")));
      sc.setName(StringHelper.null2String(map.get("name")));
      sc.setRemark(StringHelper.null2String(map.get("remark")));
      sc.setType(StringHelper.null2String(map.get("type")));
      sc.setOtabname(StringHelper.null2String(map.get("otabname")));
      sc.setOfield(StringHelper.null2String(map.get("ofield")));
      sc.setOconvert(StringHelper.null2String(map.get("oconvert")));
      sc.setOremark(StringHelper.null2String(map.get("oremark")));
      sc.setIsdelete(StringHelper.null2String(map.get("isdelete")));
      sc.setRfcid(StringHelper.null2String(map.get("rfcid")));
      sapConfigList.add(sc);
    }
    return sapConfigList;
  }

  public List<SapConfig> getInputSapConfigs(String id)
  {
    List sapConfigList = new ArrayList();
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    StringBuffer buffer = new StringBuffer(256);
    buffer.append("select * from sapconfig where (otabname is not null or oconvert is not null) and isdelete = 0 and type = 'parameter' ");
    buffer.append("and rfcid = '").append(id).append("' ");
    buffer.append("and pid in (select id from sapconfig where type='input' and isdelete = 0 ");
    buffer.append("and pid='").append(id).append("')");

    String sql = buffer.toString();
    List list = baseJdbc.executeSqlForList(sql);
    for (int i = 0; i < list.size(); i++) {
      SapConfig sc = new SapConfig();
      Map map = (Map)list.get(i);
      sc.setId(StringHelper.null2String(map.get("id")));
      sc.setPid(StringHelper.null2String(map.get("pid")));
      sc.setName(StringHelper.null2String(map.get("name")));
      sc.setRemark(StringHelper.null2String(map.get("remark")));
      sc.setType(StringHelper.null2String(map.get("type")));
      sc.setOtabname(StringHelper.null2String(map.get("otabname")));
      sc.setOfield(StringHelper.null2String(map.get("ofield")));
      sc.setOconvert(StringHelper.null2String(map.get("oconvert")));
      sc.setOremark(StringHelper.null2String(map.get("oremark")));
      sc.setIsdelete(StringHelper.null2String(map.get("isdelete")));
      sc.setRfcid(StringHelper.null2String(map.get("rfcid")));
      sapConfigList.add(sc);
    }
    return sapConfigList;
  }

  public List<SapConfig> findOutputSapConfigs(String id)
  {
    List sapConfigList = new ArrayList();
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    StringBuffer buffer = new StringBuffer(256);
    buffer.append("select * from sapconfig where isdelete = 0 and type = 'parameter' ");
    buffer.append("and rfcid = '").append(id).append("' ");
    buffer.append("and pid in (select id from sapconfig where type='output' and isdelete = 0 ");
    buffer.append("and pid='").append(id).append("')");
    String sql = buffer.toString();
    List list = baseJdbc.executeSqlForList(sql);
    for (int i = 0; i < list.size(); i++) {
      SapConfig sc = new SapConfig();
      Map map = (Map)list.get(i);
      sc.setId(StringHelper.null2String(map.get("id")));
      sc.setPid(StringHelper.null2String(map.get("pid")));
      sc.setName(StringHelper.null2String(map.get("name")));
      sc.setRemark(StringHelper.null2String(map.get("remark")));
      sc.setType(StringHelper.null2String(map.get("type")));
      sc.setOtabname(StringHelper.null2String(map.get("otabname")));
      sc.setOfield(StringHelper.null2String(map.get("ofield")));
      sc.setOconvert(StringHelper.null2String(map.get("oconvert")));
      sc.setOremark(StringHelper.null2String(map.get("oremark")));
      sc.setIsdelete(StringHelper.null2String(map.get("isdelete")));
      sc.setRfcid(StringHelper.null2String(map.get("rfcid")));
      sapConfigList.add(sc);
    }
    return sapConfigList;
  }

  public List<SapConfig> getOutputSapConfigs(String id)
  {
    List sapConfigList = new ArrayList();
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    StringBuffer buffer = new StringBuffer(512);
    buffer.append("select * from sapconfig where (otabname is not null or oconvert is not null) and isdelete = 0 and type = 'parameter' ");
    buffer.append("and rfcid = '").append(id).append("' ");
    buffer.append("and pid in (select id from sapconfig where type='output' and isdelete = 0 ");
    buffer.append("and pid='").append(id).append("')");
    String sql = buffer.toString();
    List list = baseJdbc.executeSqlForList(sql);
    for (int i = 0; i < list.size(); i++) {
      SapConfig sc = new SapConfig();
      Map map = (Map)list.get(i);
      sc.setId(StringHelper.null2String(map.get("id")));
      sc.setPid(StringHelper.null2String(map.get("pid")));
      sc.setName(StringHelper.null2String(map.get("name")));
      sc.setRemark(StringHelper.null2String(map.get("remark")));
      sc.setType(StringHelper.null2String(map.get("type")));
      sc.setOtabname(StringHelper.null2String(map.get("otabname")));
      sc.setOfield(StringHelper.null2String(map.get("ofield")));
      sc.setOconvert(StringHelper.null2String(map.get("oconvert")));
      sc.setOremark(StringHelper.null2String(map.get("oremark")));
      sc.setIsdelete(StringHelper.null2String(map.get("isdelete")));
      sc.setRfcid(StringHelper.null2String(map.get("rfcid")));
      sapConfigList.add(sc);
    }
    return sapConfigList;
  }

  public Map<SapConfig, List<SapConfig>> findInTableSapConfigs(String id)
  {
    Map scMap = new HashMap();

    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    StringBuffer buffer = new StringBuffer(256);
    buffer.append("select * from sapconfig where isdelete = 0 and type = 'table' ");
    buffer.append("and rfcid = '").append(id).append("' ");
    buffer.append("and pid in (select id from sapconfig where type='input' and isdelete = 0 ");
    buffer.append("and pid='").append(id).append("')");
    String sql = buffer.toString();
    List list = baseJdbc.executeSqlForList(sql);
    for (int i = 0; i < list.size(); i++) {
      SapConfig sc = new SapConfig();
      Map map = (Map)list.get(i);
      sc.setId(StringHelper.null2String(map.get("id")));
      sc.setPid(StringHelper.null2String(map.get("pid")));
      sc.setName(StringHelper.null2String(map.get("name")));
      sc.setRemark(StringHelper.null2String(map.get("remark")));
      sc.setType(StringHelper.null2String(map.get("type")));
      sc.setOtabname(StringHelper.null2String(map.get("otabname")));
      sc.setOfield(StringHelper.null2String(map.get("ofield")));
      sc.setOconvert(StringHelper.null2String(map.get("oconvert")));
      sc.setOremark(StringHelper.null2String(map.get("oremark")));
      sc.setIsdelete(StringHelper.null2String(map.get("isdelete")));
      sc.setRfcid(StringHelper.null2String(map.get("rfcid")));
      scMap.put(sc, findColunmSapConfigs(sc));
    }
    return scMap;
  }

  public Map<SapConfig, List<SapConfig>> getInTableSapConfigs(String id)
  {
    Map scMap = new HashMap();

    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    StringBuffer buffer = new StringBuffer(256);
    buffer.append("select * from sapconfig where (otabname is not null or oconvert is not null) and isdelete = 0 and type = 'table' ");
    buffer.append("and rfcid = '").append(id).append("' ");
    buffer.append("and pid in (select id from sapconfig where type='input' and isdelete = 0 ");
    buffer.append("and pid='").append(id).append("')");
    String sql = buffer.toString();
    List list = baseJdbc.executeSqlForList(sql);
    for (int i = 0; i < list.size(); i++) {
      SapConfig sc = new SapConfig();
      Map map = (Map)list.get(i);
      sc.setId(StringHelper.null2String(map.get("id")));
      sc.setPid(StringHelper.null2String(map.get("pid")));
      sc.setName(StringHelper.null2String(map.get("name")));
      sc.setRemark(StringHelper.null2String(map.get("remark")));
      sc.setType(StringHelper.null2String(map.get("type")));
      sc.setOtabname(StringHelper.null2String(map.get("otabname")));
      sc.setOfield(StringHelper.null2String(map.get("ofield")));
      sc.setOconvert(StringHelper.null2String(map.get("oconvert")));
      sc.setOremark(StringHelper.null2String(map.get("oremark")));
      sc.setIsdelete(StringHelper.null2String(map.get("isdelete")));
      sc.setRfcid(StringHelper.null2String(map.get("rfcid")));
      List columns = findColunmSapConfigs(sc);
      if ((columns != null) && (columns.size() > 0))
        scMap.put(sc, findColunmSapConfigs(sc));
    }
    return scMap;
  }

  public Map<SapConfig, List<SapConfig>> findOutTableSapConfigs(String id)
  {
    Map scMap = new HashMap();

    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    StringBuffer buffer = new StringBuffer(256);
    buffer.append("select * from sapconfig where isdelete = 0 and type = 'table' ");
    buffer.append("and rfcid = '").append(id).append("' ");
    buffer.append("and pid in (select id from sapconfig where type='output' and isdelete = 0 ");
    buffer.append("and pid='").append(id).append("')");
    String sql = buffer.toString();
    List list = baseJdbc.executeSqlForList(sql);
    for (int i = 0; i < list.size(); i++) {
      SapConfig sc = new SapConfig();
      Map map = (Map)list.get(i);
      sc.setId(StringHelper.null2String(map.get("id")));
      sc.setPid(StringHelper.null2String(map.get("pid")));
      sc.setName(StringHelper.null2String(map.get("name")));
      sc.setRemark(StringHelper.null2String(map.get("remark")));
      sc.setType(StringHelper.null2String(map.get("type")));
      sc.setOtabname(StringHelper.null2String(map.get("otabname")));
      sc.setOfield(StringHelper.null2String(map.get("ofield")));
      sc.setOconvert(StringHelper.null2String(map.get("oconvert")));
      sc.setOremark(StringHelper.null2String(map.get("oremark")));
      sc.setIsdelete(StringHelper.null2String(map.get("isdelete")));
      sc.setRfcid(StringHelper.null2String(map.get("rfcid")));
      scMap.put(sc, findColunmSapConfigs(sc));
    }
    return scMap;
  }

  public Map<SapConfig, List<SapConfig>> getOutTableSapConfigs(String id)
  {
    Map scMap = new HashMap();

    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    StringBuffer buffer = new StringBuffer(256);
    buffer.append("select * from sapconfig where (otabname is not null or oconvert is not null) and isdelete = 0 and type = 'table' ");
    buffer.append("and rfcid = '").append(id).append("' ");
    buffer.append("and pid in (select id from sapconfig where type='output' and isdelete = 0 ");
    buffer.append("and pid='").append(id).append("')");
    String sql = buffer.toString();
    List list = baseJdbc.executeSqlForList(sql);
    for (int i = 0; i < list.size(); i++) {
      SapConfig sc = new SapConfig();
      Map map = (Map)list.get(i);
      sc.setId(StringHelper.null2String(map.get("id")));
      sc.setPid(StringHelper.null2String(map.get("pid")));
      sc.setName(StringHelper.null2String(map.get("name")));
      sc.setRemark(StringHelper.null2String(map.get("remark")));
      sc.setType(StringHelper.null2String(map.get("type")));
      sc.setOtabname(StringHelper.null2String(map.get("otabname")));
      sc.setOfield(StringHelper.null2String(map.get("ofield")));
      sc.setOconvert(StringHelper.null2String(map.get("oconvert")));
      sc.setOremark(StringHelper.null2String(map.get("oremark")));
      sc.setIsdelete(StringHelper.null2String(map.get("isdelete")));
      sc.setRfcid(StringHelper.null2String(map.get("rfcid")));
      scMap.put(sc, getColunmSapConfigs(sc));
    }
    return scMap;
  }

  public List<SapConfig> findColunmSapConfigs(SapConfig sapConfig)
  {
    List sapConfigList = new ArrayList();
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    StringBuffer buffer = new StringBuffer(256);
    buffer.append("select * from sapconfig where isdelete = 0 and type = 'column' ");
    buffer.append("and rfcid = '").append(sapConfig.getRfcid()).append("' ");
    buffer.append("and pid ='").append(sapConfig.getId()).append("' ");
    String sql = buffer.toString();
    List list = baseJdbc.executeSqlForList(sql);
    for (int i = 0; i < list.size(); i++) {
      SapConfig sc = new SapConfig();
      Map map = (Map)list.get(i);
      sc.setId(StringHelper.null2String(map.get("id")));
      sc.setPid(StringHelper.null2String(map.get("pid")));
      sc.setName(StringHelper.null2String(map.get("name")));
      sc.setRemark(StringHelper.null2String(map.get("remark")));
      sc.setType(StringHelper.null2String(map.get("type")));
      sc.setOtabname(StringHelper.null2String(map.get("otabname")));
      sc.setOfield(StringHelper.null2String(map.get("ofield")));
      sc.setOconvert(StringHelper.null2String(map.get("oconvert")));
      sc.setOremark(StringHelper.null2String(map.get("oremark")));
      sc.setIsdelete(StringHelper.null2String(map.get("isdelete")));
      sc.setRfcid(StringHelper.null2String(map.get("rfcid")));
      sapConfigList.add(sc);
    }
    return sapConfigList;
  }

  public List<SapConfig> getColunmSapConfigs(SapConfig sapConfig)
  {
    List sapConfigList = new ArrayList();
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    StringBuffer buffer = new StringBuffer(256);
    buffer.append("select * from sapconfig where (otabname is not null or oconvert is not null) and isdelete = 0 and type = 'column' ");
    buffer.append("and rfcid = '").append(sapConfig.getRfcid()).append("' ");
    buffer.append("and pid ='").append(sapConfig.getId()).append("' ");
    String sql = buffer.toString();
    List list = baseJdbc.executeSqlForList(sql);
    for (int i = 0; i < list.size(); i++) {
      SapConfig sc = new SapConfig();
      Map map = (Map)list.get(i);
      sc.setId(StringHelper.null2String(map.get("id")));
      sc.setPid(StringHelper.null2String(map.get("pid")));
      sc.setName(StringHelper.null2String(map.get("name")));
      sc.setRemark(StringHelper.null2String(map.get("remark")));
      sc.setType(StringHelper.null2String(map.get("type")));
      sc.setOtabname(StringHelper.null2String(map.get("otabname")));
      sc.setOfield(StringHelper.null2String(map.get("ofield")));
      sc.setOconvert(StringHelper.null2String(map.get("oconvert")));
      sc.setOremark(StringHelper.null2String(map.get("oremark")));
      sc.setIsdelete(StringHelper.null2String(map.get("isdelete")));
      sc.setRfcid(StringHelper.null2String(map.get("rfcid")));
      sapConfigList.add(sc);
    }
    return sapConfigList;
  }

  public List<Formfield> findFormfields(SapConfig sc)
  {
    ForminfoService fiService = (ForminfoService)BaseContext.getBean("forminfoService");
    FormfieldService ffService = (FormfieldService)BaseContext.getBean("formfieldService");
    List fieldList = new ArrayList();
    List infoList = fiService.getForminfoListByHql("from Forminfo where objtablename = '" + sc.getOtabname() + "' and isdelete = 0 ");
    if (infoList.size() > 0)
      fieldList = ffService.findFormfield("from Formfield where  formid = '" + ((Forminfo)infoList.get(0)).getId() + "'");
    return fieldList;
  }

  public int updateSapConfig(SapConfig sc)
  {
    int retnum = 0;
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    StringBuffer buffer = new StringBuffer(1024);
    buffer.append("update sapconfig set ");
    buffer.append("otabname = '").append(sc.getOtabname()).append("',");
    buffer.append("oconvert = '").append(sc.getOconvert()).append("',");
    buffer.append("oremark = '").append(sc.getOremark()).append("',");
    buffer.append("isdelete = '").append(sc.getIsdelete()).append("' ");
    buffer.append("where id = '").append(sc.getId()).append("' ");

    String updateSql = buffer.toString();
    retnum = baseJdbc.update(updateSql);
    return retnum;
  }

  public int updateFuncRemark(SapConfig sc)
  {
    int retnum = 0;
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    StringBuffer buffer = new StringBuffer(1024);
    buffer.append("update sapconfig set ");
    buffer.append("remark = '").append(sc.getRemark()).append("' ");
    buffer.append("where id = '").append(sc.getId()).append("' ");

    String updateSql = buffer.toString();
    retnum = baseJdbc.update(updateSql);
    return retnum;
  }

  public int updateSapConfigs(List<SapConfig> sapConfigs)
  {
    int retnum = 0;
    for (int i = 0; i < sapConfigs.size(); i++) {
      retnum += updateSapConfig((SapConfig)sapConfigs.get(i));
    }
    return retnum;
  }

  public int deleteSapConfigsByRfcId(String rfcid)
  {
    int retnum = 0;
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    StringBuffer buffer = new StringBuffer(1024);
    buffer.append("update sapconfig set isdelete = '1' ");
    buffer.append("where rfcid = '").append(rfcid).append("' ");
    String updateSql = buffer.toString();
    retnum = baseJdbc.update(updateSql);
    return retnum;
  }

  public int overloadSapConfig(SapConfig sc)
  {
    int retnum = 0;
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    StringBuffer buffer = new StringBuffer(256);
    buffer.append("update sapconfig set isdelete = '0' ");
    buffer.append("where id = '").append(sc.getId()).append("' ");
    String updateSql = buffer.toString();
    retnum = baseJdbc.update(updateSql);
    return retnum;
  }

  public int deleteSapConfig(SapConfig sc)
  {
    int retnum = 0;
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    StringBuffer buffer = new StringBuffer(256);
    buffer.append("update sapconfig set isdelete = '1' ");
    buffer.append("where id = '").append(sc.getId()).append("' ");
    String updateSql = buffer.toString();
    retnum = baseJdbc.update(updateSql);
    return retnum;
  }

  public int inputToOutput(String scid)
  {
    int retnum = 0;
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    StringBuffer buffer = new StringBuffer(1024);
    buffer.append("update sapconfig s ");
    buffer.append("set s.pid = (select id from sapconfig a where a.rfcid = ");
    buffer.append("(select rfcid from sapconfig where id = s.id ) ");
    buffer.append("and a.type = 'output' and a.isdelete = 0) where s.id = '").append(scid).append("'");
    String updateSql = buffer.toString();
    retnum = baseJdbc.update(updateSql);
    return retnum;
  }

  public int outputToInput(String scid)
  {
    int retnum = 0;
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    StringBuffer buffer = new StringBuffer(1024);
    buffer.append("update sapconfig s ");
    buffer.append("set s.pid = (select id from sapconfig a where a.rfcid = ");
    buffer.append("(select rfcid from sapconfig where id = s.id ) ");
    buffer.append("and a.type = 'input' and a.isdelete = 0) where s.id = '").append(scid).append("'");
    String updateSql = buffer.toString();
    retnum = baseJdbc.update(updateSql);
    return retnum;
  }

  public int overloadInputParameters(SapConfig function, JCoFunction rfc)
  {
    int retnum = 0;
    List inputs = findInputSapConfigs(function.getRfcid());
    for (int i = 0; i < inputs.size(); i++) {
      deleteSapConfig((SapConfig)inputs.get(i));
    }
    if (rfc.getImportParameterList() != null) {
      for (int i = 0; i < rfc.getImportParameterList().getMetaData().getFieldCount(); i++)
        if (notExistSapConfig(inputs, rfc.getImportParameterList().getMetaData().getName(i))) {
          SapConfig sc = new SapConfig();
          sc.setId(IDGernerator.getUnquieID());
          sc.setPid(inputId(function.getRfcid()));
          sc.setName(rfc.getImportParameterList().getMetaData().getName(i));
          sc.setRemark(rfc.getImportParameterList().getMetaData().getDescription(i));
          sc.setType("parameter");
          sc.setOtabname("");
          sc.setOfield("");
          sc.setOconvert("");
          sc.setOremark("");
          sc.setIsdelete("0");
          sc.setRfcid(((SapConfig)inputs.get(0)).getRfcid());
          saveSapConfig(sc);
        }
    }
    return retnum;
  }

  public int overloadOutputParameters(SapConfig function, JCoFunction rfc)
  {
    int retnum = 0;
    List outputs = findOutputSapConfigs(function.getRfcid());
    for (int i = 0; i < outputs.size(); i++) {
      deleteSapConfig((SapConfig)outputs.get(i));
    }
    if (rfc.getExportParameterList() != null) {
      for (int i = 0; i < rfc.getExportParameterList().getMetaData().getFieldCount(); i++)
        if (notExistSapConfig(outputs, rfc.getExportParameterList().getMetaData().getName(i))) {
          SapConfig sc = new SapConfig();
          sc.setId(IDGernerator.getUnquieID());
          sc.setPid(outputId(function.getRfcid()));
          sc.setName(rfc.getExportParameterList().getMetaData().getName(i));
          sc.setRemark(rfc.getExportParameterList().getMetaData().getDescription(i));
          sc.setType("parameter");
          sc.setOtabname("");
          sc.setOfield("");
          sc.setOconvert("");
          sc.setOremark("");
          sc.setIsdelete("0");
          sc.setRfcid(function.getRfcid());
          saveSapConfig(sc);
        }
    }
    return retnum;
  }

  public int overloadTables(SapConfig function, JCoFunction rfc)
  {
    int retnum = 0;
    List tables = findTables(function.getRfcid());
    for (int i = 0; i < tables.size(); i++) {
      deleteSapConfig((SapConfig)tables.get(i));
    }
    if (rfc.getTableParameterList() != null) {
      for (int i = 0; i < rfc.getTableParameterList().getMetaData().getFieldCount(); i++)
        if (notExistSapConfig(tables, rfc.getTableParameterList().getMetaData().getName(i))) {
          SapConfig sc = new SapConfig();
          sc.setId(IDGernerator.getUnquieID());
          sc.setPid(inputId(function.getRfcid()));
          sc.setName(rfc.getTableParameterList().getMetaData().getName(i));
          sc.setRemark(rfc.getTableParameterList().getMetaData().getDescription(i));
          sc.setType("table");
          sc.setOtabname("");
          sc.setOfield("");
          sc.setOconvert("");
          sc.setOremark("");
          sc.setIsdelete("0");
          sc.setRfcid(function.getRfcid());
          saveSapConfig(sc);
        }
    }
    return retnum;
  }
  public int overloadColumns(SapConfig function, JCoFunction rfc) {
    int retnum = 0;
    List tables = findTables(function.getRfcid());
    for (int i = 0; i < tables.size(); i++) {
      JCoTable jcoTable = rfc.getTableParameterList().getTable(((SapConfig)tables.get(i)).getName());

      List colunms = findSapConfigsByPid(((SapConfig)tables.get(i)).getId());
      for (int j = 0; j < jcoTable.getNumColumns(); j++) {
        if (notExistSapConfig(colunms, jcoTable.getMetaData().getName(j))) {
          SapConfig sc = new SapConfig();
          sc.setId(IDGernerator.getUnquieID());
          sc.setPid(((SapConfig)tables.get(i)).getId());
          sc.setName(jcoTable.getMetaData().getName(j));
          sc.setRemark(jcoTable.getMetaData().getDescription(j));
          sc.setType("column");
          sc.setOtabname("");
          sc.setOfield("");
          sc.setOconvert("");
          sc.setOremark("");
          sc.setIsdelete("0");
          sc.setRfcid(function.getRfcid());
          saveSapConfig(sc);
        }

      }

    }

    return retnum;
  }
  public boolean notExistSapConfig(List<SapConfig> sapConfigs, String name) {
    for (int i = 0; i < sapConfigs.size(); i++) {
      if (name.equals(((SapConfig)sapConfigs.get(i)).getName())) {
        overloadSapConfig((SapConfig)sapConfigs.get(i));
        return false;
      }
    }
    return true;
  }
}