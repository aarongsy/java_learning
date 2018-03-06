package com.eweaver.app.sap.product;

import com.eweaver.base.AbstractAction;
import com.eweaver.base.DataService;
import com.eweaver.base.util.NumberHelper;
import com.eweaver.base.util.StringFilter;
import com.eweaver.base.util.StringHelper;
import com.sap.conn.jco.JCoTable;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

public class MaterialSyncAction
  implements AbstractAction
{
  protected final Log logger = LogFactory.getLog(getClass());
  private HttpServletRequest request;
  private HttpServletResponse response;
  private HttpSession session;
  private DataService dataService;
  private int pageNo;
  private int pageSize;

  public MaterialSyncAction(HttpServletRequest request, HttpServletResponse response)
  {
    this.request = request;
    this.response = response;
    this.session = request.getSession();
    this.dataService = new DataService();
  }

  public void execute() throws IOException, ServletException
  {
    this.pageNo = NumberHelper.string2Int(
      StringFilter.filterAll(this.request.getParameter("pageno")), 1);
    this.pageSize = NumberHelper.string2Int(
      StringFilter.filterAll(this.request.getParameter("pagesize")), 20);

    if (!StringHelper.isEmpty(StringFilter.filterAll(this.request
      .getParameter("start"))))
      this.pageNo = (NumberHelper.string2Int(
        StringFilter.filterAll(this.request.getParameter("start")), 0) / 
        this.pageSize + 1);
    String action = StringHelper.null2String(StringFilter.filterAll(this.request
      .getParameter("action")));
    if (action.equals("search")) {
      Material_Z_CCP_MAT_DG app = new Material_Z_CCP_MAT_DG("Z_CCP_MAT_DG");

      String material = StringHelper.null2String(
        StringFilter.filterAll(this.request.getParameter("material")));
      String plant = StringHelper.null2String(
        StringFilter.filterAll(this.request.getParameter("plant")));
      String bom_usage = StringHelper.null2String(
        StringFilter.filterAll(this.request.getParameter("bom_usage")));

      Map matertialMap = app.findData(material, plant, bom_usage);
      JCoTable mainTable = (JCoTable)matertialMap.get("main");
      JCoTable detailTable = (JCoTable)matertialMap.get("detail");

      JSONArray array = new JSONArray();

      if (mainTable != null) {
        for (int i = 0; i < mainTable.getNumRows(); i++) {
          JSONObject object = new JSONObject();

          object.put("packcode", StringHelper.null2String(mainTable.getString("MATNR")));
          object.put("packname", StringHelper.null2String(mainTable.getString("MAKTX")));
          object.put("packnum", StringHelper.null2String(mainTable.getString("QUAN")));
          object.put("packunit", StringHelper.null2String(mainTable.getString("UNIT")));

          array.add(object);
          mainTable.nextRow();
        }

      }

      JSONObject objectresult = new JSONObject();
      objectresult.put("result", array);
      objectresult.put("totalcount", Integer.valueOf(array.size()));
      try {
        this.response.getWriter().print(objectresult.toString());
      } catch (IOException e) {
        e.printStackTrace();
      }
      return;
    }if (action.equals("synchronous")) {
      String jsonstr = StringHelper.null2String(
        StringFilter.filterAll(this.request.getParameter("jsonstr")));
      String plant = StringHelper.null2String(
        StringFilter.filterAll(this.request.getParameter("plant")));
      String bom_usage = StringHelper.null2String(
        StringFilter.filterAll(this.request.getParameter("bom_usage")));
      Material_Z_CCP_MAT_DG app = new Material_Z_CCP_MAT_DG("Z_CCP_MAT_DG");
      try
      {
        String[] str = jsonstr.split(",");
        for (int i = 0; i < str.length; i++) {
          app.saveMaterial(str[i], plant, bom_usage);
        }
        this.response.getWriter().print("同步结束 ！");
      } catch (IOException e) {
        e.printStackTrace();
      }
      return;
    }
  }
}