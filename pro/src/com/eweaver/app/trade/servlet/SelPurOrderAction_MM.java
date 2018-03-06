package com.eweaver.app.trade.servlet;

import com.eweaver.app.trade.service.SelPurDetail_MM;
import com.eweaver.app.trade.service.SelPurchase_ZOA_MM_PO_INFO_MM;
import com.eweaver.base.AbstractAction;
import com.eweaver.base.DataService;
import com.eweaver.base.util.NumberHelper;
import com.eweaver.base.util.StringFilter;
import com.eweaver.base.util.StringHelper;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

public class SelPurOrderAction_MM
  implements AbstractAction
{
  protected final Log logger = LogFactory.getLog(getClass());
  private HttpServletRequest request;
  private HttpServletResponse response;
  private HttpSession session;
  private DataService dataService;
  private int pageNo;
  private int pageSize;

  public SelPurOrderAction_MM(HttpServletRequest request, HttpServletResponse response)
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
      SelPurchase_ZOA_MM_PO_INFO_MM app = new SelPurchase_ZOA_MM_PO_INFO_MM(
        "ZOA_MM_PO_INFO_EN");
      String ebeln = StringHelper.null2String(StringFilter.filterAll(this.request.getParameter("ebeln")));
      if (ebeln.trim().length() > 0) {
        List orderlist = new ArrayList();
        orderlist = app.getDetailData(ebeln);

        JSONArray array = new JSONArray();
        if (orderlist != null) {
          for (int i = 0; i < orderlist.size(); i++) {
            SelPurDetail_MM selpurdetail = new SelPurDetail_MM();
            selpurdetail = (SelPurDetail_MM)orderlist.get(i);

            JSONObject object = new JSONObject();
            object.put("pono", StringHelper.null2String(selpurdetail.getZpono()));
            object.put("poitem", StringHelper.null2String(selpurdetail.getZpoitem()));
            object.put("wlh", StringHelper.null2String(selpurdetail.getZwlh()));
            object.put("shorttxt", StringHelper.null2String(selpurdetail.getZshorttxt()));
            object.put("quantity", StringHelper.null2String(selpurdetail.getZquantity()));
            object.put("unit", StringHelper.null2String(selpurdetail.getZunit()));
            object.put("shipdate", StringHelper.null2String(selpurdetail.getZshipdate()));
            object.put("price", StringHelper.null2String(selpurdetail.getZprice()));
            object.put("currency", StringHelper.null2String(selpurdetail.getZcurrency()));
            object.put("amount", StringHelper.null2String(selpurdetail.getZamount()));
            object.put("cgsqtype", StringHelper.null2String(selpurdetail.getZcgsqtype2()));
            object.put("cgsqorder", StringHelper.null2String(selpurdetail.getZcgsqorder2()));
            object.put("cgsqitem", StringHelper.null2String(selpurdetail.getZcgsqitem()));
            object.put("qgquan", StringHelper.null2String(selpurdetail.getZqgquan()));
            object.put("baseunit", StringHelper.null2String(selpurdetail.getZbaseunit()));
            object.put("inorder", StringHelper.null2String(selpurdetail.getZinnerorder()));
            object.put("assetno", StringHelper.null2String(selpurdetail.getZassetno()));
            object.put("kmfp", StringHelper.null2String(selpurdetail.getZkmfp()));
            object.put("taxcode", StringHelper.null2String(selpurdetail.getZtaxcode()));
            object.put("taxprice", StringHelper.null2String(selpurdetail.getZtaxprice()));

            object.put("ordertype", StringHelper.null2String(selpurdetail.getZordertype()));
            object.put("ordertypedes", StringHelper.null2String(selpurdetail.getZordertypedes()));
            object.put("supcode", StringHelper.null2String(selpurdetail.getZsupcode()));
            object.put("supname", StringHelper.null2String(selpurdetail.getZsupname()));
            object.put("paytermcode", StringHelper.null2String(selpurdetail.getZpaytermcode()));
            object.put("paytermdesc", StringHelper.null2String(selpurdetail.getZpaytermdesc()));
            object.put("icon1", StringHelper.null2String(selpurdetail.getZicon1()));
            object.put("icon1desc", StringHelper.null2String(selpurdetail.getZicon1desc()));
            object.put("icon2", StringHelper.null2String(selpurdetail.getZicon2()));
            object.put("ordercur", StringHelper.null2String(selpurdetail.getZordercur()));
            object.put("rate", StringHelper.null2String(selpurdetail.getZrate()));
            object.put("orderdate", StringHelper.null2String(selpurdetail.getZorderdate()));
            object.put("totalamt", StringHelper.null2String(selpurdetail.getZtotalamt()));
            object.put("totaltaxamt", StringHelper.null2String(selpurdetail.getZtotaltaxamt()));
            object.put("comcode", StringHelper.null2String(selpurdetail.getZcomcode()));
            object.put("company", StringHelper.null2String(selpurdetail.getZcompany()));
            object.put("pzflag", StringHelper.null2String(selpurdetail.getZpzflag()));
            object.put("pudate", StringHelper.null2String(selpurdetail.getZudate()));
            object.put("supperson", StringHelper.null2String(selpurdetail.getSupperson()));
            array.add(object);
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
    }
  }
}