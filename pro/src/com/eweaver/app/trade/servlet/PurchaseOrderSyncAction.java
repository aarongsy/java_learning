package com.eweaver.app.trade.servlet;

import com.eweaver.app.trade.service.PurchaseOrder_ZOA_MM_PO_INFO;
import com.eweaver.base.AbstractAction;
import com.eweaver.base.DataService;
import com.eweaver.base.util.NumberHelper;
import com.eweaver.base.util.StringFilter;
import com.eweaver.base.util.StringHelper;
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

public class PurchaseOrderSyncAction
  implements AbstractAction
{
  protected final Log logger = LogFactory.getLog(getClass());
  private HttpServletRequest request;
  private HttpServletResponse response;
  private HttpSession session;
  private DataService dataService;
  private int pageNo;
  private int pageSize;

  public PurchaseOrderSyncAction(HttpServletRequest request, HttpServletResponse response)
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
    this.pageSize = 
      NumberHelper.string2Int(StringFilter.filterAll(this.request
      .getParameter("pagesize")), 20);

    if (!StringHelper.isEmpty(StringFilter.filterAll(this.request
      .getParameter("start"))))
      this.pageNo = (NumberHelper.string2Int(
        StringFilter.filterAll(this.request.getParameter("start")), 0) / 
        this.pageSize + 1);
    String action = StringHelper.null2String(StringFilter.filterAll(this.request
      .getParameter("action")));
    if (action.equals("search")) {
      PurchaseOrder_ZOA_MM_PO_INFO app = new PurchaseOrder_ZOA_MM_PO_INFO(
        "ZOA_MM_PO_INFO");

      String ebeln = StringHelper.null2String(StringFilter.filterAll(this.request.getParameter("ebeln")));

      Map map = app.findData(ebeln);

      JSONArray array = new JSONArray();

      if (map != null) {
        JSONObject object = new JSONObject();

        object.put("ebele", StringHelper.null2String((String)map.get("ebele")));
        object.put("bsart", StringHelper.null2String((String)map.get("bsart")));
        object.put("batxt", StringHelper.null2String((String)map.get("batxt")));
        object.put("lifnr", StringHelper.null2String((String)map.get("lifnr")));
        object.put("name1", StringHelper.null2String((String)map.get("name1")));
        object.put("zterm", StringHelper.null2String((String)map.get("zterm")));
        object.put("text1", StringHelper.null2String((String)map.get("text1")));
        object.put("inco1", StringHelper.null2String((String)map.get("inco1")));
        object.put("bezei", StringHelper.null2String((String)map.get("bezei")));
        object.put("inco2", StringHelper.null2String((String)map.get("inco2")));
        object.put("waers", StringHelper.null2String((String)map.get("waers")));
        object.put("wkurs", StringHelper.null2String((String)map.get("wkurs")));
        object.put("bedat", StringHelper.null2String((String)map.get("bedat")));

        object.put("rlwrt", StringHelper.null2String((String)map.get("rlwrt")));
        object.put("taxes", StringHelper.null2String((String)map.get("taxes")));
        object.put("bbsrt", StringHelper.null2String((String)map.get("bbsrt")));
        object.put("bukrs", StringHelper.null2String((String)map.get("bukrs")));
        object.put("butxt", StringHelper.null2String((String)map.get("butxt")));

        array.add(object);
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
      String jsonstr = StringHelper.null2String(StringFilter.filterAll(this.request
        .getParameter("jsonstr")));
      PurchaseOrder_ZOA_MM_PO_INFO app = new PurchaseOrder_ZOA_MM_PO_INFO(
        "ZOA_MM_PO_INFO");
      try
      {
        String[] str = jsonstr.split(",");
        for (int i = 0; i < str.length; i++) {
          app.savePurchaseOrder(str[i]);
        }
        if (str.length < 1)
          this.response.getWriter().print("未选择同步数据！");
        else
          this.response.getWriter().print("同步结束！");
      }
      catch (IOException e) {
        e.printStackTrace();
      }
      return;
    }
  }
}