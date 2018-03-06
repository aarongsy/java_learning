package com.eweaver.app.sap.iface;

import com.eweaver.app.configsap.SapConfig;
import com.eweaver.app.configsap.SapConfigService;
import com.eweaver.app.configsap.SapConnector;
import com.eweaver.base.AbstractAction;
import com.eweaver.base.DataService;
import com.eweaver.base.util.StringFilter;
import com.eweaver.base.util.StringHelper;
import com.sap.conn.jco.JCoFunction;
import com.sap.conn.jco.JCoParameterList;
import com.sap.conn.jco.JCoTable;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

public class WorkflowDealAction
  implements AbstractAction
{
  protected final Log logger = LogFactory.getLog(getClass());
  private HttpServletRequest request;
  private HttpServletResponse response;
  private HttpSession session;
  private DataService dataService;

  public WorkflowDealAction(HttpServletRequest request, HttpServletResponse response)
  {
    this.request = request;
    this.response = response;
    this.session = request.getSession();
    this.dataService = new DataService();
  }

  public void execute()
    throws IOException, ServletException
  {
    String action = StringHelper.null2String(StringFilter.filterAll(this.request
      .getParameter("action")));
    if (action.equals("search")) {
      String rfcid = StringHelper.null2String(StringFilter.filterAll(this.request
        .getParameter("rfcid")));
      boolean istable = false;
      try {
        SapConfigService scService = new SapConfigService();
        SapConfig sc = scService.findSapConfigById(rfcid);

        List inputList = scService.findInputSapConfigs(rfcid);
        List outputList = scService.findOutputSapConfigs(rfcid);
        Map outTableMap = scService.findOutTableSapConfigs(rfcid);
        SapConnector sapConnector = new SapConnector();
        JCoFunction function = SapConnector.getRfcFunction(sc.getName());
        for (int i = 0; i < inputList.size(); i++) {
          function.getImportParameterList().setValue(((SapConfig)inputList.get(i)).getName(), converValue(((SapConfig)inputList.get(i)).getOconvert(), StringHelper.null2String(StringFilter.filterAll(this.request.getParameter(((SapConfig)inputList.get(i)).getId() + "_input")))));
        }
        function.execute(SapConnector.getDestination("sanpowersap"));
        JCoParameterList returnStructure = function.getTableParameterList();
        JSONArray array = new JSONArray();

        for (Map.Entry entry : outTableMap.entrySet()) {
          istable = true;
          JCoTable ret = function.getTableParameterList().getTable(((SapConfig)entry.getKey()).getName());
          if (ret != null) {
            for (int r = 0; r < ret.getNumRows(); r++) {
              JSONObject object = new JSONObject();
              for (int c = 0; c < ((List)entry.getValue()).size(); c++) {
                object.put(((SapConfig)((List)entry.getValue()).get(c)).getId(), converValue(((SapConfig)((List)entry.getValue()).get(c)).getOconvert(), StringHelper.null2String(ret.getString(((SapConfig)((List)entry.getValue()).get(c)).getName()))));
              }
              array.add(object);
              ret.nextRow();
            }
          }
        }
        if (!istable) {
          JSONObject object = new JSONObject();
          for (int o = 0; o < outputList.size(); o++) {
            object.put(((SapConfig)outputList.get(o)).getId(), converValue(((SapConfig)outputList.get(o)).getOconvert(), StringHelper.null2String(function.getExportParameterList().getValue(((SapConfig)outputList.get(o)).getName()))));
          }
          array.add(object);
        }

        JSONObject objectresult = new JSONObject();
        objectresult.put("result", array);
        objectresult.put("totalcount", Integer.valueOf(array.size()));

        this.response.getWriter().print(objectresult.toString());
      }
      catch (Exception e) {
        e.printStackTrace();
      }
      return;
    }
  }

  public String converValue(String converStr, String ovalue)
  {
    String sql = converStr.replaceAll("currentFieldValue", ovalue);
    if (converStr.trim().length() > 0) {
      String str = StringHelper.null2String(this.dataService.getValue(sql));
      ovalue = str.length() > 0 ? str : ovalue;
    }
    return ovalue;
  }
}