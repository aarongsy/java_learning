package com.eweaver.app.sap.common;

import com.eweaver.app.configsap.SapConnector;
import com.eweaver.base.util.StringHelper;
import com.sap.conn.jco.JCoField;
import com.sap.conn.jco.JCoFieldIterator;
import com.sap.conn.jco.JCoFunction;
import com.sap.conn.jco.JCoParameterList;
import com.sap.conn.jco.JCoTable;
import java.io.PrintStream;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

public class SAPQuerySyncService
{
  public JSONObject getSapTable(String functionName, String paramName, String paramValue, String returnTableName, String returnFieldName, boolean ispage)
  {
    JSONObject result = new JSONObject();
    JSONArray array = new JSONArray();
    SapConnector sapConnector = new SapConnector();
    try {
      JCoFunction function = SapConnector.getRfcFunction(functionName);
      if (function == null) {
        System.out.println(functionName + " not found in SAP.");
        System.out.println("SAP_RFC中没有此函数!");
        return result;
      }
      String[] paramNames = paramName.split(",");
      String[] paramValues = paramValue.split(",");
      for (int i = 0; i < paramNames.length; i++)
      {
        String pv = paramValues[i];
        if (StringHelper.isEmpty(paramValues[i])) {
          pv = "";
        }
        function.getImportParameterList().setValue(paramNames[i], pv);
      }

      function.execute(SapConnector.getDestination("sanpowersap"));

      JCoParameterList returnStructure = function.getTableParameterList();
      JCoTable productTable = null;
      if (StringHelper.isEmpty(returnTableName))
        productTable = returnStructure.getTable(0);
      else {
        productTable = returnStructure.getTable(returnTableName);
      }
      String[] returnFieldNames = returnFieldName.split(",");
      for (int i = 0; i < productTable.getNumRows(); i++) {
        JSONObject object = new JSONObject();
        object.put("indexNo", Integer.valueOf(i + 1));
        for (int j = 0; j < returnFieldNames.length; j++) {
          object.put(returnFieldNames[j], StringHelper.null2String(productTable.getString(returnFieldNames[j])));
        }
        array.add(object);
        productTable.nextRow();
      }
      String PAGE_NUM = "8000";
      if (ispage)
        PAGE_NUM = function.getExportParameterList().getString("PAGE_NUM");
      result.put("pageCount", PAGE_NUM);
      result.put("array", array);
    } catch (Exception e) {
      e.printStackTrace();
    }

    return result;
  }

  public JSONObject getSapReturnParam(String functionName, String paramName, String paramValue)
  {
    JSONObject object = new JSONObject();
    try {
      SapConnector sapConnector = new SapConnector();
      JCoFunction function = SapConnector.getRfcFunction(functionName);
      if (function == null) {
        System.out.println(functionName + " not found in SAP.");
        System.out.println("SAP_RFC中没有此函数!");
        return object;
      }
      String[] paramNames = paramName.split(",");
      String[] paramValues = paramValue.split(",");

      for (int i = 0; i < paramNames.length; i++) {
        String pv = StringHelper.null2String(paramValues[i]);
        if (StringHelper.isEmpty(paramValues[i])) {
          pv = "";
        }
        function.getImportParameterList().setValue(paramNames[i], pv);
      }

      function.execute(SapConnector.getDestination("sanpowersap"));

      JCoParameterList returnStructure = function.getExportParameterList();
      JCoFieldIterator fieldIterator = returnStructure.getFieldIterator();
      while (fieldIterator.hasNextField()) {
        JCoField nextfield = fieldIterator.nextField();
        String expName = nextfield.getName();
        String expValue = StringHelper.null2String(returnStructure.getValue(expName));
        object.put(expName, expValue);
      }
    } catch (Exception e) {
      e.printStackTrace();
    }

    return object;
  }
}