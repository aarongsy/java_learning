package com.eweaver.app.sap.product;

import com.eweaver.base.AbstractAction;
import com.eweaver.base.DataService;
import com.eweaver.base.util.NumberHelper;
import com.eweaver.base.util.StringFilter;
import com.eweaver.base.util.StringHelper;
import com.sap.conn.jco.JCoTable;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

public class OrderSyncAction
  implements AbstractAction
{
  protected final Log logger = LogFactory.getLog(getClass());
  private HttpServletRequest request;
  private HttpServletResponse response;
  private HttpSession session;
  private DataService dataService;
  private int pageNo;
  private int pageSize;

  public OrderSyncAction(HttpServletRequest request, HttpServletResponse response)
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
      Order_Z_CCP_ORDER_DG app = new Order_Z_CCP_ORDER_DG(
        "Z_CCP_ORDER_DG");
      String werks = StringHelper.null2String(StringFilter.filterAll(this.request.getParameter("werks")));
      String wadat = StringHelper.null2String(StringFilter.filterAll(this.request.getParameter("wadat")));
      String wadae = StringHelper.null2String(StringFilter.filterAll(this.request.getParameter("wadae")));
      String vbeln_vl = StringHelper.null2String(StringFilter.filterAll(this.request.getParameter("vbeln_vl")));
      if ((vbeln_vl.trim().length() > 0) || ((wadat.trim().length() > 0) && (wadae.trim().length() > 0))) {
        JCoTable orderTable = app.findData(vbeln_vl, wadat, wadae, werks);

        JSONArray array = new JSONArray();
        if (orderTable != null) {
          for (int i = 0; i < orderTable.getNumRows(); i++) {
            JSONObject object = new JSONObject();

            object.put("salesdocno", StringHelper.null2String(orderTable.getString("VBELN_VA")));
            object.put("salesitem", StringHelper.null2String(orderTable.getString("POSNR_VA")));
            object.put("salestype", StringHelper.null2String(orderTable.getString("AUART")));
            object.put("customerno", StringHelper.null2String(orderTable.getString("BSTNK")));
            object.put("soldto", StringHelper.null2String(orderTable.getString("KUNAG")));
            object.put("soldtoname", StringHelper.null2String(orderTable.getString("NAME_SOLD")));
            object.put("shipto", StringHelper.null2String(orderTable.getString("KUNNR")));
            object.put("shiptoname", StringHelper.null2String(orderTable.getString("NAME_SHIP")));
            object.put("shiptoaddress", StringHelper.null2String(orderTable.getString("ADD_SHIP")));
            object.put("materialno", StringHelper.null2String(orderTable.getString("MATNR")));
            object.put("materialdesc", StringHelper.null2String(orderTable.getString("MAKTX")));
            object.put("quantity", StringHelper.null2String(orderTable.getString("KWMENG")));
            object.put("salesunit", StringHelper.null2String(orderTable.getString("VRKME")));
            object.put("unitoftext", StringHelper.null2String(orderTable.getString("MSEHT")));
            object.put("plant", StringHelper.null2String(orderTable.getString("WERKS")));
            object.put("materialtype", StringHelper.null2String(orderTable.getString("VKAUS")));
            object.put("planneddate", StringHelper.null2String(orderTable.getString("WADAT")));
            object.put("packagecode", StringHelper.null2String(orderTable.getString("AESKD")));
            object.put("dangerous", StringHelper.null2String(orderTable.getString("FERTH")));
            object.put("goodsgroup", StringHelper.null2String(orderTable.getString("SPART")));

            array.add(object);

            orderTable.nextRow();
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
      }
      return;
    }if (action.equals("synchronous")) {
      String jsonstr = StringHelper.null2String(StringFilter.filterAll(this.request
        .getParameter("jsonstr")));
      Order_Z_CCP_ORDER_DG app = new Order_Z_CCP_ORDER_DG(
        "Z_CCP_ORDER_DG");
      try
      {
        String[] str = jsonstr.split(",");
        for (int i = 0; i < str.length; i++)
        {
          app.saveOrder(str[i]);
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