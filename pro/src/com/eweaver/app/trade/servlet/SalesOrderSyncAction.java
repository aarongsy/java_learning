package com.eweaver.app.trade.servlet;

import com.eweaver.app.trade.service.SalesOrder_ZOA_SD_SO_INFO;
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

public class SalesOrderSyncAction
  implements AbstractAction
{
  protected final Log logger = LogFactory.getLog(getClass());
  private HttpServletRequest request;
  private HttpServletResponse response;
  private HttpSession session;
  private DataService dataService;
  private int pageNo;
  private int pageSize;

  public SalesOrderSyncAction(HttpServletRequest request, HttpServletResponse response)
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
    String VBELN_VL = StringHelper.null2String(
      StringFilter.filterAll(this.request.getParameter("VBELN")));

    if (action.equals("search")) {
      SalesOrder_ZOA_SD_SO_INFO app = new SalesOrder_ZOA_SD_SO_INFO(
        "ZOA_SD_SO_INFO");

      String vbeln = StringHelper.null2String(StringFilter.filterAll(this.request.getParameter("vbeln")));

      Map map = app.findData(vbeln);

      JSONArray array = new JSONArray();

      if (map != null) {
        JSONObject object = new JSONObject();
        object.put("vbeln", StringHelper.null2String((String)map.get("vbeln")));
        object.put("auart", StringHelper.null2String((String)map.get("auart")));
        object.put("typed", StringHelper.null2String((String)map.get("typed")));
        object.put("bstnk", StringHelper.null2String((String)map.get("bstnk")));
        object.put("prctr", StringHelper.null2String((String)map.get("prctr")));
        object.put("bukrs_vf", StringHelper.null2String((String)map.get("bukrs_vf")));
        object.put("butxt", StringHelper.null2String((String)map.get("butxt")));
        object.put("sdabw", StringHelper.null2String((String)map.get("sdabw")));
        object.put("specd", StringHelper.null2String((String)map.get("specd")));
        object.put("kunnr", StringHelper.null2String((String)map.get("kunnr")));
        object.put("name1", StringHelper.null2String((String)map.get("name1")));
        object.put("land1", StringHelper.null2String((String)map.get("land1")));
        object.put("stras1", StringHelper.null2String((String)map.get("stras1")));
        object.put("sunnr", StringHelper.null2String((String)map.get("sunnr")));
        object.put("name2", StringHelper.null2String((String)map.get("name2")));
        object.put("land2", StringHelper.null2String((String)map.get("land2")));
        object.put("stras2", StringHelper.null2String((String)map.get("stras2")));
        object.put("zterm", StringHelper.null2String((String)map.get("zterm")));
        object.put("text1", StringHelper.null2String((String)map.get("text1")));
        object.put("inco1", StringHelper.null2String((String)map.get("inco1")));
        object.put("bezei", StringHelper.null2String((String)map.get("bezei")));
        object.put("inco2", StringHelper.null2String((String)map.get("inco2")));
        object.put("waerk", StringHelper.null2String((String)map.get("waerk")));
        object.put("zlsch", StringHelper.null2String((String)map.get("zlsch")));
        object.put("text2", StringHelper.null2String((String)map.get("text2")));

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
      SalesOrder_ZOA_SD_SO_INFO app = new SalesOrder_ZOA_SD_SO_INFO(
        "ZOA_SD_SO_INFO");
      try
      {
        String[] str = jsonstr.split(",");
        for (int i = 0; i < str.length; i++)
        {
          app.saveSaleOrder(str[i]);
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

  public void synchronous() { String jsonstr = StringHelper.null2String(StringFilter.filterAll(this.request
      .getParameter("jsonstr")));
    try
    {
      this.response.getWriter().print("asdasd");
    } catch (IOException e) {
      e.printStackTrace();
    }
  }
}