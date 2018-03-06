package com.eweaver.app.sap.iface;

import com.eweaver.app.configsap.SapConnector;
import com.eweaver.base.util.StringHelper;
import com.sap.conn.jco.JCoFunction;
import com.sap.conn.jco.JCoParameterList;
import com.sap.conn.jco.JCoTable;
import java.io.PrintStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Function_sap
{
  public String functionname;

  public static void main(String[] str)
  {
    Function_sap app = new Function_sap("ZOA_SD_CREDIT_LETTER");
    app.set_ZOA_SD_CREDIT_LETTER(new HashMap());
  }

  public Function_sap(String functionname)
  {
    setFunctionname(functionname);
  }

  public Map<String, String> set_ZOA_SD_CREDIT_LETTER(Map<String, String> inMap)
  {
    try
    {
      Map retMap = new HashMap();
      SapConnector sapConnector = new SapConnector();
      String functionName = "ZOA_SD_CREDIT_LETTER";
      JCoFunction function = SapConnector.getRfcFunction(functionName);
      if (function == null) {
        System.out.println(functionName + " not found in SAP.");
        System.out.println("SAP_RFC中没有此函数!");
        retMap.put("ERR_MSG", functionName + " not found in SAP.");
      }

      if (inMap.containsKey("bukrs"))
        function.getImportParameterList().setValue("BUKRS", (String)inMap.get("bukrs"));
      if (inMap.containsKey("kunnr"))
        function.getImportParameterList().setValue("KUNNR", (String)inMap.get("kunnr"));
      if (inMap.containsKey("waemp"))
        function.getImportParameterList().setValue("WAEMP", (String)inMap.get("waemp"));
      if (inMap.containsKey("banks"))
        function.getImportParameterList().setValue("BANKS", (String)inMap.get("banks"));
      if (inMap.containsKey("bankl"))
        function.getImportParameterList().setValue("BANKL", (String)inMap.get("bankl"));
      if (inMap.containsKey("baanr"))
        function.getImportParameterList().setValue("BAANR", (String)inMap.get("baanr"));
      if (inMap.containsKey("wrtak"))
        function.getImportParameterList().setValue("WRTAK", (String)inMap.get("wrtak"));
      if (inMap.containsKey("waers"))
        function.getImportParameterList().setValue("WAERS", (String)inMap.get("waers"));
      if (inMap.containsKey("datay"))
        function.getImportParameterList().setValue("DATAY", (String)inMap.get("datay"));
      if (inMap.containsKey("datxa"))
        function.getImportParameterList().setValue("DATXA", (String)inMap.get("datxa"));
      if (inMap.containsKey("datai"))
        function.getImportParameterList().setValue("DATAI", (String)inMap.get("datai"));
      if (inMap.containsKey("inco1"))
        function.getImportParameterList().setValue("INCO1", (String)inMap.get("inco1"));
      if (inMap.containsKey("inco2"))
        function.getImportParameterList().setValue("INCO2", (String)inMap.get("inco2"));
      function.getImportParameterList().setValue("RUN_MODE", "");

      function.execute(SapConnector.getDestination("sanpowersap"));

      JCoParameterList returnStructure = function.getTableParameterList();

      retMap.put("FLAG", function.getExportParameterList().getValue("FLAG").toString());
      retMap.put("ERR_MSG", function.getExportParameterList().getValue("ERR_MSG").toString());
      retMap.put("LCNUM", function.getExportParameterList().getValue("LCNUM").toString());

      return retMap;
    } catch (Exception e) {
      e.printStackTrace();
    }

    return null;
  }

  public List<Map<String, String>> get_ZOA_MM_VENDOR_LIST(String ktokk, String lifnr, String name1, String out_rows)
  {
    try
    {
      List retList = new ArrayList();

      String err_msg = "";
      SapConnector sapConnector = new SapConnector();
      String functionName = "ZOA_MM_VENDOR_LIST";
      JCoFunction function = SapConnector.getRfcFunction(functionName);
      if (function == null) {
        System.out.println(functionName + " not found in SAP.");
        System.out.println("SAP_RFC中没有此函数!");
        err_msg = functionName + " not found in SAP.";
      }

      function.getImportParameterList().setValue("KTOKK", ktokk);
      function.getImportParameterList().setValue("LIFNR", lifnr);
      function.getImportParameterList().setValue("NAME1", name1);
      function.getImportParameterList().setValue("OUT_ROWS", out_rows);

      function.execute(SapConnector.getDestination("sanpowersap"));

      JCoParameterList returnStructure = function.getTableParameterList();
      String flag = function.getExportParameterList().getValue("FLAG").toString();
      err_msg = function.getExportParameterList().getValue("ERR_MSG").toString();
      String lcnum = function.getExportParameterList().getValue("LCNUM").toString();
      JCoTable retTable = function.getTableParameterList().getTable("MM_VD_LIST");
      if (retTable != null) {
        for (int i = 0; i < retTable.getNumRows(); i++) {
          Map retMap = new HashMap();

          retMap.put("flag", flag);
          retMap.put("err_msg", err_msg);
          retMap.put("lcnum", lcnum);

          retMap.put("lifnr", StringHelper.null2String(retTable.getString("LIFNR")));
          retMap.put("name1", StringHelper.null2String(retTable.getString("NAME1")));

          retList.add(retMap);
          retTable.nextRow();
        }
      }

      return retList;
    } catch (Exception e) {
      e.printStackTrace();
    }

    return null;
  }

  public Map<String, Object> set_All(String functionName, Map<String, Object> mapStr)
  {
    Map retMap = new HashMap();

    return retMap;
  }
  public String getFunctionname() {
    return this.functionname;
  }

  public void setFunctionname(String functionname) {
    this.functionname = functionname;
  }
}