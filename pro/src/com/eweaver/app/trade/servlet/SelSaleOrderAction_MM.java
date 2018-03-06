package com.eweaver.app.trade.servlet;

import com.eweaver.app.trade.service.SelSODetail_MM;
import com.eweaver.app.trade.service.SelSaleOrder_ZOA_SD_SO_INFO_MM;
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

public class SelSaleOrderAction_MM
  implements AbstractAction
{
  protected final Log logger = LogFactory.getLog(getClass());
  private HttpServletRequest request;
  private HttpServletResponse response;
  private HttpSession session;
  private DataService dataService;
  private int pageNo;
  private int pageSize;

  public SelSaleOrderAction_MM(HttpServletRequest request, HttpServletResponse response)
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
      SelSaleOrder_ZOA_SD_SO_INFO_MM app = new SelSaleOrder_ZOA_SD_SO_INFO_MM(
        "ZOA_SD_SO_INFO_MM");
      String vbeln = StringHelper.null2String(StringFilter.filterAll(this.request.getParameter("vbeln")));
      if (vbeln.trim().length() > 0) {
        List orderlist = new ArrayList();
        orderlist = app.getDetailData(vbeln);

        JSONArray array = new JSONArray();
        if (orderlist != null) {
          for (int i = 0; i < orderlist.size(); i++) {
            SelSODetail_MM selsodetail = new SelSODetail_MM();
            selsodetail = (SelSODetail_MM)orderlist.get(i);

            JSONObject object = new JSONObject();
            object.put("sono", StringHelper.null2String(selsodetail.getZsono()));
            object.put("soitem", StringHelper.null2String(selsodetail.getZsoitem()));
            object.put("wlh", StringHelper.null2String(selsodetail.getZwlh()));
            object.put("shortxt", StringHelper.null2String(selsodetail.getZshorttxt()));
            object.put("quantity", StringHelper.null2String(selsodetail.getZquantity()));
            object.put("unit", StringHelper.null2String(selsodetail.getZunit()));
            object.put("gcxg", StringHelper.null2String(selsodetail.getZgcxg()));
            object.put("whloc", StringHelper.null2String(selsodetail.getZwhloc()));
            object.put("batchno", StringHelper.null2String(selsodetail.getZbatchno()));
            object.put("shipdate", StringHelper.null2String(selsodetail.getZshipdate()));
            object.put("basequan", StringHelper.null2String(selsodetail.getZbasequan()));
            object.put("baseunit", StringHelper.null2String(selsodetail.getZbaseunit()));
            object.put("price", StringHelper.null2String(selsodetail.getZprice()));
            object.put("amount", StringHelper.null2String(selsodetail.getZamount()));
            object.put("packdesc", StringHelper.null2String(selsodetail.getZpackdesc()));
            object.put("commission", StringHelper.null2String(selsodetail.getZcommission()));

            object.put("ordertype", StringHelper.null2String(selsodetail.getZordertype()));
            object.put("ordertypedes", StringHelper.null2String(selsodetail.getZordertypedes()));
            object.put("pono", StringHelper.null2String(selsodetail.getZpono()));
            object.put("profit", StringHelper.null2String(selsodetail.getZprofit()));
            object.put("speflag", StringHelper.null2String(selsodetail.getZspeflag()));
            object.put("speflagdesc", StringHelper.null2String(selsodetail.getZspeflagdesc()));
            object.put("sellto", StringHelper.null2String(selsodetail.getZsellto()));
            object.put("selltoname", StringHelper.null2String(selsodetail.getZselltoname()));
            object.put("selltocontry", StringHelper.null2String(selsodetail.getZselltocontry()));
            object.put("selltoaddr", StringHelper.null2String(selsodetail.getZselltoaddr()));
            object.put("sendto", StringHelper.null2String(selsodetail.getZsendto()));
            object.put("sendtoname", StringHelper.null2String(selsodetail.getZsendtoname()));
            object.put("sendtocontry", StringHelper.null2String(selsodetail.getZsendtocontry()));
            object.put("sendtoaddr", StringHelper.null2String(selsodetail.getZsendtoaddr()));
            object.put("paytermcode", StringHelper.null2String(selsodetail.getZpaytermcode()));
            object.put("paytermdesc", StringHelper.null2String(selsodetail.getZpaytermdesc()));
            object.put("icon1", StringHelper.null2String(selsodetail.getZicon1()));
            object.put("icon1desc", StringHelper.null2String(selsodetail.getZicon1desc()));
            object.put("icon2", StringHelper.null2String(selsodetail.getZicon2()));
            object.put("currency", StringHelper.null2String(selsodetail.getZcurrency()));
            object.put("paycode", StringHelper.null2String(selsodetail.getZpaycode()));
            object.put("paycodedesc", StringHelper.null2String(selsodetail.getZpaycodedesc()));
            object.put("comcode", StringHelper.null2String(selsodetail.getZcomcode()));
            object.put("company", StringHelper.null2String(selsodetail.getZcompany()));
            object.put("costcen", StringHelper.null2String(selsodetail.getZcostcenm()));
            object.put("cpdl", StringHelper.null2String(selsodetail.getZcpdlm()));
            object.put("fxqd", StringHelper.null2String(selsodetail.getZfxqdm()));
            object.put("khtj", StringHelper.null2String(selsodetail.getZkhtjm()));
            object.put("pckdes", StringHelper.null2String(selsodetail.getPcdes()));
            object.put("zcredit", StringHelper.null2String(selsodetail.getZcredit()));
            
            object.put("zeta", StringHelper.null2String(selsodetail.getZeta()));//预计到港日
            object.put("zetd", StringHelper.null2String(selsodetail.getZetd()));//预计开航日
            object.put("zcldate", StringHelper.null2String(selsodetail.getZcldate()));//预计结关日
            object.put("zkhwlms", StringHelper.null2String(selsodetail.getZkhwlms()));//客户物料描述
            object.put("zkhbz", StringHelper.null2String(selsodetail.getZkhbz()));//客户备注
            object.put("zpzhb", StringHelper.null2String(selsodetail.getZpzhb()));//SD凭证货币
            object.put("zjjz", StringHelper.null2String(selsodetail.getZjjz()));//净价值
            object.put("zkhcgddrq", StringHelper.null2String(selsodetail.getZkhcgddrq()));//客户采购订单日期
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